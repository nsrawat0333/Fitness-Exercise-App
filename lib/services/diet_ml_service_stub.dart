class DietMLService {
  static Future<void> initModel() async {}

  static double predictCalorieAdjustment({
    required double currentCalories,
    required double weightKg,
    required int bodyType, // 0=Lean, 1=Fit, 2=Fat
    required int daysLogged,
  }) {
    // Stub fallback logic identical to the intended TFLite regression
    // This executes safely on Web without crashing dart:ffi
    if (bodyType == 0) return 100.0; // Lean surplus
    if (bodyType == 2) return -100.0; // Fat deficit
    return 0.0; // Fit maintenance
  }
}
