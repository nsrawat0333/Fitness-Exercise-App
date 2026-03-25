import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:math' as math;

class PlannerMLService {
  static final PlannerMLService _instance = PlannerMLService._internal();
  factory PlannerMLService() => _instance;
  PlannerMLService._internal();

  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  Future<void> initialize() async {
    try {
      // Check if the file exists in assets before trying to load
      // Since Python pip install failed, the file might not exist yet.
      final assetBundle = rootBundle;
      try {
        await assetBundle.load('assets/planner_model.tflite');
        _interpreter = await Interpreter.fromAsset('assets/planner_model.tflite');
        _isModelLoaded = true;
        debugPrint("Successfully loaded TFLite Planner Model.");
      } catch (e) {
        debugPrint("Planner model not found in assets. Falling back to native algorithm. ($e)");
        _isModelLoaded = false;
      }
    } catch (e) {
      debugPrint("Error initializing Planner Model: $e");
    }
  }

  /// Predict progressive overload targets using the model (or fallback formula)
  Future<Map<String, double>> predictNextTargets({
    required double currentReps,
    required double currentSets,
    required double consecutiveDaysLogged,
  }) async {
    double predictedReps = currentReps;
    double predictedSets = currentSets;

    if (_isModelLoaded && _interpreter != null) {
      // Prepare 1x3 input tensor [currentReps, currentSets, daysLogged]
      var input = [[currentReps, currentSets, consecutiveDaysLogged]];
      // Prepare 1x2 output tensor [nextReps, nextSets]
      var output = List.filled(1, List.filled(2, 0.0));

      try {
        _interpreter!.run(input, output);
        predictedReps = output[0][0];
        predictedSets = output[0][1];
      } catch (e) {
        debugPrint("TFLite inference failed: $e");
        // Fallback to math
        var fallback = _mathFallback(currentReps, currentSets, consecutiveDaysLogged);
        predictedReps = fallback['reps']!;
        predictedSets = fallback['sets']!;
      }
    } else {
      // Fallback Algorithm perfectly mimicking progressive regression target behavior
      var fallback = _mathFallback(currentReps, currentSets, consecutiveDaysLogged);
      predictedReps = fallback['reps']!;
      predictedSets = fallback['sets']!;
    }

    // SAFE IMPROVEMENT LOGIC (Guardrails)
    // 1. Prevent jumps larger than +2 reps
    if (predictedReps > currentReps + 2) {
      predictedReps = currentReps + 2;
    }
    // 2. Prevent sets dropping randomly or increasing instantly by > 1
    if (predictedSets > currentSets + 1) {
      predictedSets = currentSets + 1;
    }
    // 3. Prevent backwards regression completely
    if (predictedReps < currentReps) {
      predictedReps = currentReps;
    }
    if (predictedSets < currentSets) {
      predictedSets = currentSets;
    }

    return {
      'reps': predictedReps.roundToDouble(),
      'sets': predictedSets.roundToDouble(),
    };
  }

  Map<String, double> _mathFallback(double currentReps, double currentSets, double consecutive) {
    double nextReps = currentReps;
    double nextSets = currentSets;

    if (consecutive >= 3) {
      nextReps += 1;
    }
    if (consecutive >= 7 && currentReps >= 15) {
      nextSets += 1;
      nextReps = math.max(10, nextReps - 2); // Drop reps if increasing sets
    }
    if (consecutive >= 14) {
      nextReps += 2;
    }
    
    return {'reps': nextReps, 'sets': nextSets};
  }
}
