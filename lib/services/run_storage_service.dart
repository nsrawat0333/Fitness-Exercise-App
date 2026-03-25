import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/run_data.dart';

/// Persists run history locally using SharedPreferences.
class RunStorageService {
  static const _key = 'run_history';

  static Future<List<RunRecord>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => RunRecord.fromJson(e as Map<String, dynamic>)).toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  static Future<void> saveRun(RunRecord record) async {
    final history = await loadHistory();
    history.insert(0, record);
    // Keep last 100 runs max
    final trimmed = history.take(100).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(trimmed.map((r) => r.toJson()).toList()));
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// Aggregated stats for dashboard
  static Future<Map<String, dynamic>> getWeeklyStats() async {
    final history = await loadHistory();
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final thisWeek = history.where((r) => r.startTime.isAfter(weekAgo)).toList();
    final lastWeekStart = weekAgo.subtract(const Duration(days: 7));
    final lastWeek = history.where((r) => r.startTime.isAfter(lastWeekStart) && r.startTime.isBefore(weekAgo)).toList();

    final totalDistKm = thisWeek.fold<double>(0, (s, r) => s + r.distanceKm);
    final totalTimeSec = thisWeek.fold<int>(0, (s, r) => s + r.durationSeconds);
    final runsCount = thisWeek.length;
    final totalSteps = thisWeek.fold<int>(0, (s, r) => s + r.steps);

    final lastWeekDist = lastWeek.fold<double>(0, (s, r) => s + r.distanceKm);
    final improvement = lastWeekDist > 0 ? ((totalDistKm - lastWeekDist) / lastWeekDist * 100).round() : 0;

    return {
      'totalDistKm': totalDistKm,
      'totalTimeSec': totalTimeSec,
      'runsCount': runsCount,
      'totalSteps': totalSteps,
      'improvement': improvement,
      'thisWeekRuns': thisWeek,
    };
  }
}
