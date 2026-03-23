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
}
