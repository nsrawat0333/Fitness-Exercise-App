import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DietMLService {
  static Interpreter? _interpreter;

  static Future<void> initModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/diet_model.tflite');
      debugPrint("Diet TFLite Model loaded natively (mobile).");
    } catch (e) {
      debugPrint("Failed to load Diet TFLite model natively: $e");
    }
  }

  static double predictCalorieAdjustment({
    required double currentCalories,
    required double weightKg,
    required int bodyType,
    required int daysLogged,
  }) {
    // 1. Stub/Fallback Logic if TFLite model isn't populated
    double fallbackDelta = 0.0;
    if (bodyType == 0) fallbackDelta = 75.0;  // Safe surplus for Lean
    if (bodyType == 2) fallbackDelta = -75.0; // Safe deficit for Fat

    // 2. TFLite Native Inference Logic
    if (_interpreter == null) {
      return fallbackDelta;
    }

    try {
      // Shape matches python training script: [weight, calories, bodyType, daysLogged]
      var input = [[weightKg, currentCalories, bodyType.toDouble(), daysLogged.toDouble()]];
      var output = List.filled(1, 0.0).reshape([1, 1]);
      _interpreter!.run(input, output);
      
      double predictedDelta = (output[0][0] as double);
      
      // 3. Strict Safety Guardrails
      // We do not allow the ML model to jump calories too extremely in a single day.
      predictedDelta = predictedDelta.clamp(-150.0, 150.0);
      return predictedDelta;
    } catch (e) {
      debugPrint("Diet ML Inference error: $e");
      return fallbackDelta;
    }
  }
}
