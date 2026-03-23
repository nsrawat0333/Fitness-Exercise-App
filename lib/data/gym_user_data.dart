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
}
