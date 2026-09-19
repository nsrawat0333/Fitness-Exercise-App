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

  static const int _waterReminderStartHour = 8;
  static const int _waterReminderEndHour = 20;
  static const int _waterReminderIntervalHours = 2;
  static const int _waterReminderBaseId = 2100;
  static const String _fixedReminderIntervalLabel = 'Every 2 hours (8 AM - 8 PM)';

  Future<void> init() async {
    await _loadData();
    try {
      await _checkAndScheduleReminders();
    } catch (e) {
      debugPrint('Failed to initialize water reminders: $e');
    }
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
    waterDataNotifier.value.reminderInterval =
        prefs.getString('water_reminder_interval') ?? _fixedReminderIntervalLabel;
    if (waterDataNotifier.value.reminderInterval != _fixedReminderIntervalLabel) {
      waterDataNotifier.value.reminderInterval = _fixedReminderIntervalLabel;
      await prefs.setString('water_reminder_interval', _fixedReminderIntervalLabel);
    }
    
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
    await _checkAndScheduleReminders();
    _notify();
  }
  
  Future<void> updateReminderInterval(String interval) async {
    waterDataNotifier.value.reminderInterval = _fixedReminderIntervalLabel;
    await _saveData();
    await _checkAndScheduleReminders();
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

  Future<void> _checkAndScheduleReminders() async {
    final notifService = NotificationService();

    // Only cancel water reminder IDs, do not cancel other module notifications.
    for (int id = _waterReminderBaseId; id < _waterReminderBaseId + 24; id++) {
      await notifService.cancelNotification(id);
    }

    if (waterDataNotifier.value.remindersEnabled) {
      int i = 0;
      for (int hour = _waterReminderStartHour; hour <= _waterReminderEndHour; hour += _waterReminderIntervalHours) {
        try {
          await notifService.scheduleDailyNotificationAtTime(
            id: _waterReminderBaseId + i,
            title: 'Stay Hydrated',
            body: 'Time to drink water. Keep your recovery on track.',
            hour: hour,
            minute: 0,
            payload: 'water|$hour',
          );
        } catch (e) {
          debugPrint('Failed to schedule water reminder for $hour:00: $e');
        }
        i++;
      }
    }
  }
}
