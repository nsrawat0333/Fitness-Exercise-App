import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthData {
  final int lastBpm;
  final int pushUps;
  final int pullUps;
  final int chinUps;

  HealthData({
    this.lastBpm = 0,
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
    }
    
    healthDataNotifier.value = HealthData(
      lastBpm: prefs.getInt('last_bpm') ?? 0,
      pushUps: prefs.getInt('ai_pushups') ?? 0,
      pullUps: prefs.getInt('ai_pullups') ?? 0,
      chinUps: prefs.getInt('ai_chinups') ?? 0,
    );
  }

  Future<void> updateBpm(int bpm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_bpm', bpm);
    
    final current = healthDataNotifier.value;
    healthDataNotifier.value = HealthData(
      lastBpm: bpm,
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
      pushUps: newPush,
      pullUps: newPull,
      chinUps: newChin,
    );
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
