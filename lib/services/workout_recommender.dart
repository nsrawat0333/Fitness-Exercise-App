import '../data/gym_user_data.dart';
import '../models/body_scan_result.dart';

/// Service that provides intelligent workout and diet recommendations
/// based on user profile, body type, and fitness goals.
class WorkoutRecommender {
  WorkoutRecommender._();

  /// Get recommended diet plan key for the user.
  static String getRecommendedDietPlan(GymUserData user) {
    // Priority: body scan recommendation > fitness goal mapping
    if (user.bodyType == 'skinny') return 'Build Muscle';
    if (user.bodyType == 'fat' || user.bodyType == 'overweight') return 'Lose Weight';
    return user.dietPlanKey;
  }

  /// Get adjusted phase durations based on exercise difficulty and user level.
  /// Returns a map with keys: breathing, preview, perform, recovery.
  static Map<String, int> getAdjustedPhaseDurations({
    required String exerciseDifficulty,
    required String userLevel,
    int basePerformDuration = 30,
  }) {
    int breathing = 20;
    int preview = 20;
    int perform = basePerformDuration;
    int recovery = 20;

    // User level adjustments
    switch (userLevel.toLowerCase()) {
      case 'beginner':
        breathing = 25;
        recovery = 25;
        // Reduce hard exercises for beginners
        if (exerciseDifficulty == 'advanced') {
          perform = (basePerformDuration * 0.6).round();
        }
        break;
      case 'advanced':
        breathing = 15;
        preview = 15;
        recovery = 15;
        // Increase duration for advanced users
        perform = (basePerformDuration * 1.5).round();
        break;
      default: // intermediate
        break;
    }

    return {
      'breathing': breathing,
      'preview': preview,
      'perform': perform,
      'recovery': recovery,
    };
  }

  /// Classify body type from BMI value.
  static String getBodyTypeFromBMI(double bmi) {
    if (bmi < 18.5) return 'skinny';
    if (bmi < 25) return 'normal';
    if (bmi < 30) return 'overweight';
    return 'fat';
  }

  /// Get recommendation string from body type.
  static String getRecommendation(String bodyType) {
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

  /// Perform body scan using BMI (fallback). 
  /// In the future, this will call the TFLite ML model.
  static BodyScanResult performBodyScan(GymUserData user) {
    return BodyScanResult.fromBMI(user.bmi);
  }

  /// Update user's body type from scan result.
  static void applyBodyScanResult(GymUserData user, BodyScanResult result) {
    user.bodyType = result.bodyType;
  }
}
