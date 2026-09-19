import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthData {
  final int lastBpm;
  final int dailyAvgBpm;
  final int bpmReadingsCount;
  final int pushUps;
  final int pullUps;
  final int chinUps;

  HealthData({
    this.lastBpm = 0,
    this.dailyAvgBpm = 0,
    this.bpmReadingsCount = 0,
    this.pushUps = 0,
    this.pullUps = 0,
    this.chinUps = 0,
  });
}

class HealthStorageService {
  static final HealthStorageService _instance = HealthStorageService._internal();
  factory HealthStorageService() => _instance;
  HealthStorageService._internal();

  final ValueNotifier<HealthData> healthDataNotifier = ValueNotifier(HealthData());

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if new day
    final today = _getTodayKey();
    final lastSavedDay = prefs.getString('health_last_saved_day');
    
    if (lastSavedDay != today) {
      // Reset AI stats daily
      await prefs.setString('health_last_saved_day', today);
      await prefs.setInt('ai_pushups', 0);
      await prefs.setInt('ai_pullups', 0);
      await prefs.setInt('ai_chinups', 0);
      await prefs.setString('bpm_values_$today', '[]');
    }

    final bpmValues = _readBpmValues(prefs, today);
    
    healthDataNotifier.value = HealthData(
      lastBpm: prefs.getInt('last_bpm') ?? 0,
      dailyAvgBpm: _calculateAverageBpm(bpmValues),
      bpmReadingsCount: bpmValues.length,
      pushUps: prefs.getInt('ai_pushups') ?? 0,
      pullUps: prefs.getInt('ai_pullups') ?? 0,
      chinUps: prefs.getInt('ai_chinups') ?? 0,
    );
  }

  Future<void> updateBpm(int bpm) async {
    if (bpm <= 0) return;

    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayKey();
    final bpmValues = _readBpmValues(prefs, today);
    bpmValues.add(bpm);

    // Keep a bounded rolling list for the day.
    if (bpmValues.length > 50) {
      bpmValues.removeRange(0, bpmValues.length - 50);
    }

    await prefs.setInt('last_bpm', bpm);
    await prefs.setString('bpm_values_$today', jsonEncode(bpmValues));
    
    final current = healthDataNotifier.value;
    healthDataNotifier.value = HealthData(
      lastBpm: bpm,
      dailyAvgBpm: _calculateAverageBpm(bpmValues),
      bpmReadingsCount: bpmValues.length,
      pushUps: current.pushUps,
      pullUps: current.pullUps,
      chinUps: current.chinUps,
    );
  }

  Future<void> addWorkoutReps(String activity, int reps) async {
    final prefs = await SharedPreferences.getInstance();
    final current = healthDataNotifier.value;
    
    int newPush = current.pushUps;
    int newPull = current.pullUps;
    int newChin = current.chinUps;
    
    final lowerAct = activity.toLowerCase();
    
    if (lowerAct.contains('push')) {
      newPush += reps;
      await prefs.setInt('ai_pushups', newPush);
    } else if (lowerAct.contains('pull')) {
      newPull += reps;
      await prefs.setInt('ai_pullups', newPull);
    } else if (lowerAct.contains('chin')) {
      newChin += reps;
      await prefs.setInt('ai_chinups', newChin);
    }
    
    healthDataNotifier.value = HealthData(
      lastBpm: current.lastBpm,
      dailyAvgBpm: current.dailyAvgBpm,
      bpmReadingsCount: current.bpmReadingsCount,
      pushUps: newPush,
      pullUps: newPull,
      chinUps: newChin,
    );
  }

  List<int> _readBpmValues(SharedPreferences prefs, String dayKey) {
    final raw = prefs.getString('bpm_values_$dayKey');
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded.whereType<num>().map((e) => e.toInt()).where((e) => e > 0).toList();
    } catch (_) {
      return [];
    }
  }

  int _calculateAverageBpm(List<int> bpmValues) {
    if (bpmValues.isEmpty) return 0;
    final total = bpmValues.fold<int>(0, (sum, value) => sum + value);
    return (total / bpmValues.length).round();
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
