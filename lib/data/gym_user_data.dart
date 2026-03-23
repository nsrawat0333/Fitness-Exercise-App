class GymUserData {
  static final GymUserData _instance = GymUserData._internal();

  factory GymUserData() {
    return _instance;
  }

  GymUserData._internal();

  // Selected gender
  String gender = 'male';

  // Body Focus ('Abs', 'Arm', 'Chest', 'Leg', 'Full Body', 'Shoulder & Back', 'Butt')
  String focusArea = 'Full Body';

  // Motivation ('Build Muscle', 'Keep Fit', 'Lose Weight', etc.)
  String motivation = 'Build Muscle';

  // Pushups capability ('Beginner', 'Intermediate', 'Advanced')
  String pushups = 'Beginner';

  // Activity level ('Beginner', 'Intermediate', 'Advanced')
  String activity = 'Beginner';

  // Weekly Goal Days (1 to 7)
  int weeklyGoalDays = 3;

  // Body metrics
  double heightCm = 175;
  double weightKg = 70;
  bool isHeightCm = true;
  bool isWeightKg = true;

  // ── Smart Profiling Fields ──
  // Fitness Goal: 'Weight Loss', 'Weight Gain', 'Muscle Building', 'General Fitness'
  String fitnessGoal = 'General Fitness';

  // Age (optional, 0 = not set)
  int age = 0;

  // Body type from scanner/BMI: 'skinny', 'normal', 'overweight', 'fat'
  String bodyType = 'normal';

  /// Returns workout/diet recommendation based on body type.
  /// 'diet-heavy' → more diet focus, less intense exercise
  /// 'workout-heavy' → more workouts + healthy diet
  /// 'balanced' → maintain fitness plan
  String get recommendation {
    switch (bodyType) {
      case 'skinny':
        return 'diet-heavy';
      case 'fat':
      case 'overweight':
        return 'workout-heavy';
      default:
        return 'balanced';
    }
  }

  /// Duration multiplier for exercise phases based on activity level.
  /// Beginner: shorter exercises, Advanced: longer exercises.
  double get durationMultiplier {
    switch (activity) {
      case 'Beginner':
        return 0.7;
      case 'Advanced':
        return 1.5;
      default:
        return 1.0;
    }
  }

  /// Maps fitness goal to diet plan key.
  String get dietPlanKey {
    switch (fitnessGoal) {
      case 'Weight Loss':
        return 'Lose Weight';
      case 'Weight Gain':
      case 'Muscle Building':
        return 'Build Muscle';
      default:
        return 'Keep Fit';
    }
  }

  // ── Weekly Progress Tracking ──
  int completedDays = 0;
  int currentWeek = 1;
  Set<int> completedDayIndices = {};

  // Total plan days based on difficulty
  int get totalPlanDays {
    if (activity == 'Beginner') return 7;
    if (activity == 'Intermediate') return 14;
    return 30; // Advanced
  }

  int get totalWeeks => (totalPlanDays / 7).ceil();

  bool isDayUnlocked(int dayIndex) {
    if (dayIndex == 1) return true;
    // Previous day must be completed
    return completedDayIndices.contains(dayIndex - 1);
  }

  bool isDayCompleted(int dayIndex) {
    return completedDayIndices.contains(dayIndex);
  }

  void completeDay(int dayIndex) {
    completedDayIndices.add(dayIndex);
    completedDays = completedDayIndices.length;
    currentWeek = ((completedDays - 1) / 7).floor() + 1;
    if (currentWeek < 1) currentWeek = 1;
  }

  bool isWeekCompleted(int week) {
    int startDay = (week - 1) * 7 + 1;
    int endDay = week * 7;
    if (endDay > totalPlanDays) endDay = totalPlanDays;
    for (int d = startDay; d <= endDay; d++) {
      if (!completedDayIndices.contains(d)) return false;
    }
    return true;
  }

  bool isWeekUnlocked(int week) {
    if (week == 1) return true;
    return isWeekCompleted(week - 1);
  }

  // BMI calculation
  double get bmi {
    double heightM = heightCm / 100;
    if (heightM <= 0) return 0;
    return weightKg / (heightM * heightM);
  }

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  // ── Custom Workout Plans ──
  List<Map<String, dynamic>> customPlanExercises = [];

  // ── Home Workout Program Fields ──
  /// Focus area for home workout: 'Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps', 'Abs', 'Legs', 'Glutes', 'Full Body'
  String homeWorkoutFocusArea = 'Full Body';

  /// Fitness level for home workout: 'Beginner', 'Intermediate', 'Advanced'
  String homeWorkoutLevel = 'Beginner';

  /// Goal for home workout: 'Weight Loss', 'Muscle Gain', 'Strength'
  String homeWorkoutGoal = 'Muscle Gain';

  /// Number of weeks for home workout program (1–12)
  int homeWorkoutWeeks = 4;
}
