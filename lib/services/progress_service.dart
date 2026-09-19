import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks user progress for Challenge, UFC, and Gym sections.
/// Persists data via SharedPreferences.
class ProgressService {
  static final ProgressService _instance = ProgressService._();
  factory ProgressService() => _instance;
  ProgressService._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ═══════════════════════════════════════
  //  CHALLENGE PROGRESS
  // ═══════════════════════════════════════

  /// Get highest unlocked challenge level (default: 10)
  int getUnlockedChallengeLevel() =>
      _prefs?.getInt('challenge_unlocked_level') ?? 10;

  /// Mark a challenge level as completed, unlock next
  Future<void> completeChallenge(int exerciseCount) async {
    await init();
    final current = getUnlockedChallengeLevel();
    final levels = [10, 20, 30, 50, 60, 100];
    final idx = levels.indexOf(exerciseCount);
    if (idx >= 0 && idx < levels.length - 1) {
      final nextLevel = levels[idx + 1];
      if (nextLevel > current) {
        await _prefs!.setInt('challenge_unlocked_level', nextLevel);
      }
    }

    // Track completed challenges list
    final completed = getCompletedChallenges();
    if (!completed.contains(exerciseCount)) {
      completed.add(exerciseCount);
      await _prefs!.setString('challenge_completed', jsonEncode(completed));
    }
  }

  List<int> getCompletedChallenges() {
    final raw = _prefs?.getString('challenge_completed');
    if (raw == null) return [];
    return List<int>.from(jsonDecode(raw));
  }

  /// Track individual rep/time/speed challenge best scores
  Future<void> saveRepChallengeBest(String exerciseId, int reps) async {
    await init();
    final key = 'rep_best_$exerciseId';
    final current = _prefs?.getInt(key) ?? 0;
    if (reps > current) {
      await _prefs!.setInt(key, reps);
    }
  }

  int getRepChallengeBest(String exerciseId) =>
      _prefs?.getInt('rep_best_$exerciseId') ?? 0;

  // ═══════════════════════════════════════
  //  UFC PROGRESS
  // ═══════════════════════════════════════

  /// Get completed days for a UFC course
  List<int> getUFCCompletedDays(String courseName) {
    final raw = _prefs?.getString('ufc_days_$courseName');
    if (raw == null) return [];
    return List<int>.from(jsonDecode(raw));
  }

  /// Mark a UFC day as completed
  Future<void> completeUFCDay(String courseName, int dayNumber) async {
    await init();
    final completed = getUFCCompletedDays(courseName);
    if (!completed.contains(dayNumber)) {
      completed.add(dayNumber);
      await _prefs!.setString('ufc_days_$courseName', jsonEncode(completed));
    }
  }

  bool isUFCDayCompleted(String courseName, int dayNumber) =>
      getUFCCompletedDays(courseName).contains(dayNumber);

  // ═══════════════════════════════════════
  //  GYM COURSE PROGRESS
  // ═══════════════════════════════════════

  /// Get completed exercises for a gym course + level
  List<String> getGymCompletedExercises(String courseName, String level) {
    final raw = _prefs?.getString('gym_${courseName}_$level');
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw));
  }

  Future<void> completeGymExercise(String courseName, String level, String exerciseName) async {
    await init();
    final completed = getGymCompletedExercises(courseName, level);
    if (!completed.contains(exerciseName)) {
      completed.add(exerciseName);
      await _prefs!.setString('gym_${courseName}_$level', jsonEncode(completed));
    }
  }

  // ═══════════════════════════════════════
  //  WORKOUT HISTORY
  // ═══════════════════════════════════════

  /// Log a completed workout session
  Future<void> logWorkout({
    required String type, // 'challenge', 'ufc', 'gym'
    required String name,
    int durationMinutes = 0,
    int caloriesBurned = 0,
  }) async {
    await init();
    final history = getWorkoutHistory();
    history.add({
      'type': type,
      'name': name,
      'duration': durationMinutes,
      'calories': caloriesBurned,
      'date': DateTime.now().toIso8601String(),
    });
    // Keep last 100 entries
    if (history.length > 100) {
      history.removeRange(0, history.length - 100);
    }
    await _prefs!.setString('workout_history', jsonEncode(history));
  }

  List<Map<String, dynamic>> getWorkoutHistory() {
    final raw = _prefs?.getString('workout_history');
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(
      (jsonDecode(raw) as List).map((e) => Map<String, dynamic>.from(e)),
    );
  }

  int getTotalWorkouts() => getWorkoutHistory().length;

  int getTotalMinutes() =>
      getWorkoutHistory().fold(0, (sum, w) => sum + (w['duration'] as int? ?? 0));

  int getTotalCalories() =>
      getWorkoutHistory().fold(0, (sum, w) => sum + (w['calories'] as int? ?? 0));
}
