/// Singleton to hold yoga onboarding preferences.
class YogaUserData {
  static final YogaUserData _instance = YogaUserData._internal();
  factory YogaUserData() => _instance;
  YogaUserData._internal();

  // Gender
  String gender = 'female';

  // Focus area: 'Flexibility', 'Stress Relief', 'Weight Loss', 'Core & Strength', 'Back Pain Relief', 'Full Body'
  String focusArea = 'Full Body';

  // Goal: 'Improve Flexibility', 'Reduce Stress', 'Lose Weight', 'Build Strength'
  String goal = 'Improve Flexibility';

  // Experience level: 'Beginner', 'Intermediate', 'Advanced'
  String experienceLevel = 'Beginner';

  // Activity level: 'Sedentary', 'Lightly active', 'Moderately active', 'Very active'
  String activityLevel = 'Sedentary';

  // Weekly goal days (1–7)
  int weeklyGoalDays = 3;

  // Body metrics
  double heightCm = 165;
  double weightKg = 60;
  bool isHeightCm = true;
  bool isWeightKg = true;

  // BMI
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

  /// Duration multiplier based on experience.
  double get durationMultiplier {
    switch (experienceLevel) {
      case 'Beginner':
        return 0.7;
      case 'Advanced':
        return 1.5;
      default:
        return 1.0;
    }
  }

  /// Maps yoga goal to diet plan key.
  String get dietPlanKey {
    switch (goal) {
      case 'Lose Weight':
        return 'Weight Loss';
      case 'Build Strength':
        return 'Muscle Gain';
      default:
        return 'Flexibility';
    }
  }
}
