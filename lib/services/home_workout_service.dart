import '../data/home_exercises.dart';
import '../models/home_workout_models.dart';

/// Service that generates personalized Home Workout programs.
///
/// Flow:
///   1. Load exercises for the selected focus area
///   2. Build week-by-week plan with progressive overload
///   3. Personalize based on user level and goal
class HomeWorkoutService {
  /// Generate a full workout program.
  ///
  /// [focusArea] — 'chest', 'back', 'shoulders', etc.
  /// [weeks] — number of weeks (1–12)
  /// [level] — 'Beginner', 'Intermediate', 'Advanced'
  /// [goal] — 'Weight Loss', 'Muscle Gain', 'Strength'
  static HomeWorkoutProgram generateProgram({
    required String focusArea,
    required int weeks,
    required String level,
    required String goal,
  }) {
    final exercises = HomeExercisesData.getExercisesForFocus(focusArea);
    final baseParams = _getBaseParams(level, goal);
    final weeklyPlans = <HomeWorkoutWeek>[];

    for (int w = 1; w <= weeks; w++) {
      final weekDays = <HomeWorkoutDay>[];
      final daysPerWeek = baseParams.workoutDaysPerWeek;

      for (int d = 1; d <= 7; d++) {
        // Rest days: every nth day depending on the level
        final isRestDay = _isRestDay(d, daysPerWeek);

        if (isRestDay) {
          weekDays.add(HomeWorkoutDay(
            dayNumber: d,
            title: 'Rest & Recovery',
            isRestDay: true,
            estimatedMinutes: 0,
          ));
        } else {
          // Progressive overload: increase difficulty each week
          final progression = _calculateProgression(w, weeks);
          final dayExercises = _selectExercisesForDay(
            exercises,
            d,
            baseParams,
            progression,
          );

          weekDays.add(HomeWorkoutDay(
            dayNumber: d,
            title: _getDayTitle(d, focusArea, w),
            exercises: dayExercises,
            isRestDay: false,
            estimatedMinutes: _estimateMinutes(dayExercises, baseParams),
          ));
        }
      }

      weeklyPlans.add(HomeWorkoutWeek(
        weekNumber: w,
        theme: _getWeekTheme(w, weeks),
        days: weekDays,
        difficultyLabel: _getWeekDifficulty(w, weeks),
      ));
    }

    return HomeWorkoutProgram(
      focusArea: focusArea,
      level: level,
      goal: goal,
      totalWeeks: weeks,
      weeks: weeklyPlans,
    );
  }

  /// Base workout parameters adjusted by user level and goal.
  static _WorkoutParams _getBaseParams(String level, String goal) {
    // Level adjustments
    int baseExercisesPerDay;
    int baseRestSeconds;
    int workoutDaysPerWeek;

    switch (level) {
      case 'Advanced':
        baseExercisesPerDay = 8;
        baseRestSeconds = 20;
        workoutDaysPerWeek = 6;
        break;
      case 'Intermediate':
        baseExercisesPerDay = 6;
        baseRestSeconds = 30;
        workoutDaysPerWeek = 5;
        break;
      default: // Beginner
        baseExercisesPerDay = 5;
        baseRestSeconds = 40;
        workoutDaysPerWeek = 4;
    }

    // Goal adjustments
    double repsMultiplier = 1.0;
    int restAdjustment = 0;

    switch (goal) {
      case 'Weight Loss':
        repsMultiplier = 1.2; // more reps
        restAdjustment = -5; // shorter rest
        baseExercisesPerDay += 1; // more exercises
        break;
      case 'Muscle Gain':
        repsMultiplier = 1.0;
        restAdjustment = 5; // slightly more rest
        break;
      case 'Strength':
        repsMultiplier = 0.7; // fewer reps
        restAdjustment = 10; // longer rest
        break;
    }

    return _WorkoutParams(
      exercisesPerDay: baseExercisesPerDay,
      baseRestSeconds: (baseRestSeconds + restAdjustment).clamp(10, 60),
      repsMultiplier: repsMultiplier,
      workoutDaysPerWeek: workoutDaysPerWeek,
    );
  }

  /// Determines if the given day of the week is a rest day.
  static bool _isRestDay(int dayOfWeek, int workoutDaysPerWeek) {
    // Distribute rest days evenly
    switch (workoutDaysPerWeek) {
      case 4:
        return [3, 5, 7].contains(dayOfWeek); // rest on Wed, Fri, Sun
      case 5:
        return [4, 7].contains(dayOfWeek); // rest on Thu, Sun
      case 6:
        return dayOfWeek == 7; // rest only Sunday
      default:
        return [3, 5, 7].contains(dayOfWeek);
    }
  }

  /// Progressive overload factor based on current week / total weeks.
  static _ProgressionFactor _calculateProgression(int currentWeek, int totalWeeks) {
    if (totalWeeks <= 1) {
      return const _ProgressionFactor(repsMultiplier: 1.0, restReduction: 0);
    }
    // Linear progression from week 1 to final week
    double progress = (currentWeek - 1) / (totalWeeks - 1);
    return _ProgressionFactor(
      repsMultiplier: 1.0 + (progress * 0.3), // up to 30% more reps
      restReduction: (progress * 10).round(), // up to 10s less rest
    );
  }

  /// Select and adjust exercises for a specific day.
  static List<HomeExercise> _selectExercisesForDay(
    List<HomeExercise> pool,
    int dayOfWeek,
    _WorkoutParams params,
    _ProgressionFactor progression,
  ) {
    if (pool.isEmpty) return [];

    final count = params.exercisesPerDay.clamp(1, pool.length);

    // Rotate starting index by day to vary exercises
    final startIdx = ((dayOfWeek - 1) * 2) % pool.length;
    final selected = <HomeExercise>[];

    for (int i = 0; i < count; i++) {
      final idx = (startIdx + i) % pool.length;
      final ex = pool[idx];

      // Apply progression overload
      selected.add(ex.withProgression(
        repsMultiplier: params.repsMultiplier * progression.repsMultiplier,
        restReductionSeconds: progression.restReduction,
      ));
    }

    return selected;
  }

  static int _estimateMinutes(List<HomeExercise> exercises, _WorkoutParams params) {
    if (exercises.isEmpty) return 0;
    // Rough estimate: each exercise ~1-2 min + rest between
    int totalSeconds = 0;
    for (final ex in exercises) {
      final durMatch = RegExp(r'(\d+)').firstMatch(ex.duration);
      int dur = durMatch != null ? int.parse(durMatch.group(1)!) : 30;
      totalSeconds += dur + params.baseRestSeconds;
    }
    return (totalSeconds / 60).ceil();
  }

  static String _getDayTitle(int dayOfWeek, String focusArea, int week) {
    final titles = [
      'Primary $focusArea Workout',
      'Endurance $focusArea Session',
      'Rest & Recovery',
      'Strength $focusArea Focus',
      'Power $focusArea Circuit',
      'Volume $focusArea Training',
      'Active Recovery',
    ];
    return titles[(dayOfWeek - 1) % titles.length];
  }

  static String _getWeekTheme(int week, int totalWeeks) {
    if (totalWeeks <= 1) return 'Introductory Week';
    double progress = (week - 1) / (totalWeeks - 1);
    if (progress < 0.25) return 'Foundation Building';
    if (progress < 0.50) return 'Progressive Overload';
    if (progress < 0.75) return 'Intensity Increase';
    return 'Peak Performance';
  }

  static String _getWeekDifficulty(int week, int totalWeeks) {
    if (totalWeeks <= 1) return 'Moderate';
    double progress = (week - 1) / (totalWeeks - 1);
    if (progress < 0.33) return 'Easy';
    if (progress < 0.66) return 'Moderate';
    return 'Hard';
  }
}

class _WorkoutParams {
  final int exercisesPerDay;
  final int baseRestSeconds;
  final double repsMultiplier;
  final int workoutDaysPerWeek;

  const _WorkoutParams({
    required this.exercisesPerDay,
    required this.baseRestSeconds,
    required this.repsMultiplier,
    required this.workoutDaysPerWeek,
  });
}

class _ProgressionFactor {
  final double repsMultiplier;
  final int restReduction;

  const _ProgressionFactor({
    required this.repsMultiplier,
    required this.restReduction,
  });
}
