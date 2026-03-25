import 'package:flutter/foundation.dart';

class PlannerMLService {
  static final PlannerMLService _instance = PlannerMLService._internal();
  factory PlannerMLService() => _instance;
  PlannerMLService._internal();

  Future<void> initialize() async {
    debugPrint("Planner ML natively unavailable on this platform (Web). Using stub.");
  }

  Future<Map<String, double>> predictNextTargets({
    required double currentReps,
    required double currentSets,
    required double consecutiveDaysLogged,
  }) async {
    // Basic hardcoded fallback progression for Web/Stub
    return {
      'reps': currentReps + (consecutiveDaysLogged > 2 ? 1 : 0),
      'sets': currentSets,
    };
  }
}
