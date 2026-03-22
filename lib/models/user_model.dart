/// Data model for user profile and daily activity stats.
/// Ready for future Firebase/API integration.
class UserModel {
  final String name;
  final int steps;
  final int stepGoal;
  final int waterGlasses;
  final int waterGoal;
  final int heartRate;
  final int pushUps;
  final int pullUps;
  final int chinUps;

  const UserModel({
    required this.name,
    required this.steps,
    required this.stepGoal,
    required this.waterGlasses,
    required this.waterGoal,
    required this.heartRate,
    required this.pushUps,
    required this.pullUps,
    required this.chinUps,
  });

  /// Mock data matching the screenshot.
  factory UserModel.mock() => const UserModel(
        name: 'Alex',
        steps: 5240,
        stepGoal: 10000,
        waterGlasses: 3,
        waterGoal: 5,
        heartRate: 78,
        pushUps: 12,
        pullUps: 8,
        chinUps: 5,
      );

  double get stepProgress => steps / stepGoal;
  double get waterProgress => waterGlasses / waterGoal;
  int get waterPercent => (waterProgress * 100).round();
}
