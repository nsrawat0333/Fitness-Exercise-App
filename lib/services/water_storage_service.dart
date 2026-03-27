import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/water_intake_model.dart';
import 'notification_service.dart';

class WaterStorageService {
  static final WaterStorageService _instance = WaterStorageService._internal();
  factory WaterStorageService() => _instance;
  WaterStorageService._internal();

  final ValueNotifier<WaterIntakeModel> waterDataNotifier = ValueNotifier(
    WaterIntakeModel(
      currentIntakeMl: 0,
      dailyGoalMl: 2000,
      history: [],
      reminders: [],
    ),
  );

  Future<void> init() async {
    await _loadData();
    _checkAndScheduleReminders();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayKey();
    
    // Check if new day
    final lastSavedDay = prefs.getString('water_last_saved_day');
    if (lastSavedDay != today) {
      // New day: reset current intake and history, keep goal and reminders
      waterDataNotifier.value.currentIntakeMl = 0;
      waterDataNotifier.value.history = [];
      await prefs.setString('water_last_saved_day', today);
      await prefs.setInt('water_intake_$today', 0);
      await prefs.setString('water_history_$today', '[]');
    } else {
      waterDataNotifier.value.currentIntakeMl = prefs.getInt('water_intake_$today') ?? 0;
      
      final historyJson = prefs.getString('water_history_$today');
      if (historyJson != null) {
        final List<dynamic> decodedList = jsonDebug(historyJson);
        waterDataNotifier.value.history = decodedList.map((str) {
          final parts = str.split('|');
          return WaterHistoryEntry(
            label: parts[0],
            amountMl: int.parse(parts[1]),
            time: parts[2],
          );
        }).toList();
      }
    }

    waterDataNotifier.value.dailyGoalMl = prefs.getInt('water_daily_goal') ?? 2000;
    waterDataNotifier.value.remindersEnabled = prefs.getBool('water_reminders_enabled') ?? true;
    waterDataNotifier.value.reminderInterval = prefs.getString('water_reminder_interval') ?? 'Every 2 hours';
    
    // Notify listeners
    _notify();
  }

  Future<void> addIntake(int amountMl, String label, String time) async {
    waterDataNotifier.value.currentIntakeMl += amountMl;
    waterDataNotifier.value.history.insert(
      0,
      WaterHistoryEntry(label: label, amountMl: amountMl, time: time),
    );
    await _saveData();
    _notify();
  }

  Future<void> updateGoal(int goalMl) async {
    waterDataNotifier.value.dailyGoalMl = goalMl;
    await _saveData();
    _notify();
  }

  Future<void> toggleReminders(bool enabled) async {
    waterDataNotifier.value.remindersEnabled = enabled;
    await _saveData();
    _checkAndScheduleReminders();
    _notify();
  }
  
  Future<void> updateReminderInterval(String interval) async {
    waterDataNotifier.value.reminderInterval = interval;
    await _saveData();
    _checkAndScheduleReminders();
    _notify();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayKey();
    
    await prefs.setInt('water_intake_$today', waterDataNotifier.value.currentIntakeMl);
    await prefs.setInt('water_daily_goal', waterDataNotifier.value.dailyGoalMl);
    prefs.getBool('water_reminders_enabled') ?? await prefs.setBool('water_reminders_enabled', waterDataNotifier.value.remindersEnabled);
    await prefs.setString('water_reminder_interval', waterDataNotifier.value.reminderInterval);
    
    final historyList = waterDataNotifier.value.history.map((e) => '${e.label}|${e.amountMl}|${e.time}').toList();
    await prefs.setString('water_history_$today', jsonEncode(historyList));
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  void _notify() {
    // Force UI rebuild by passing a new instance or calling notifyListeners on a custom notifier
    // In this simple setup, we just assign to the same object reference, which doesn't trigger ValueNotifier
    // So we create a shallow copy to trigger it.
    final current = waterDataNotifier.value;
    waterDataNotifier.value = WaterIntakeModel(
      currentIntakeMl: current.currentIntakeMl,
      dailyGoalMl: current.dailyGoalMl,
      selectedVesselIndex: current.selectedVesselIndex,
      remindersEnabled: current.remindersEnabled,
      reminderInterval: current.reminderInterval,
      history: List.from(current.history),
      reminders: List.from(current.reminders),
    );
  }

  List<dynamic> jsonDebug(String source) {
    try {
      return jsonDecode(source);
    } catch (e) {
      return [];
    }
  }

  void _checkAndScheduleReminders() {
    final notifService = NotificationService();
    notifService.cancelAllNotifications();

    if (waterDataNotifier.value.remindersEnabled) {
      // In a real app, use flutter_local_notifications zonedSchedule API or flutter_workmanager
      // For this implementation plan, we simulate the scheduling since exact timing requires native work
      notifService.showNotification(
        id: 100, 
        title: 'Stay Hydrated! 💧', 
        body: 'Time to drink some water. You are at ${waterDataNotifier.value.currentIntakeMl}ml today.'
      );
    }
  }
}
