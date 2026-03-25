import 'dart:convert';
import '../data/gym_exercises_catalog.dart';
import 'body_scan_service.dart';

class SmartWorkoutPlan {
  final BodyType bodyType;
  final String focusTarget;
  final List<dynamic> exercises;
  final int totalDurationMin;
  final String message;
  final String dietPlanTitle;
  final String dietPlanDetails;

  SmartWorkoutPlan({
    required this.bodyType,
    required this.focusTarget,
    required this.exercises,
    required this.totalDurationMin,
    required this.message,
    required this.dietPlanTitle,
    required this.dietPlanDetails,
  });
}

class WorkoutRecommendationEngine {
  static final List<dynamic> _allGymExercises = _loadGymExercises();

  static List<dynamic> _loadGymExercises() {
    try {
      final data = jsonDecode(gymExercisesJson);
      return data['exercises'] as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  static SmartWorkoutPlan generatePlan({
    required BodyType bodyType,
    required String mode, // 'gym' or 'yoga'
  }) {
    List<dynamic> selectedExercises = [];
    int baseDuration = 15; // default 15 mins
    String message = '';
    String focusTarget = '';

    if (mode == 'gym') {
      // ── GYM LOGIC ──
      final cardio = _allGymExercises.where((e) => e['category'] == 'cardio').toList();
      final strength = _allGymExercises.where((e) => ['chest', 'back', 'legs', 'arms', 'shoulders', 'full_body'].contains(e['category'])).toList();
      final abs = _allGymExercises.where((e) => e['category'] == 'abs').toList();
      final stretching = _allGymExercises.where((e) => e['category'] == 'stretching').toList();

      cardio.shuffle();
      strength.shuffle();
      abs.shuffle();
      stretching.shuffle();

      if (bodyType == BodyType.fat) {
        focusTarget = 'Fat Loss & Cardio';
        baseDuration = 25; // Increase duration
        message = 'We recommend fat-loss focused workouts with higher intensity and longer duration.';
        // Mix: 40% cardio (HIIT), 40% strength (full body), 20% abs
        selectedExercises = [
          ...cardio.take(4),
          ...strength.take(3),
          ...abs.take(2),
          ...stretching.take(1),
        ];
      } else if (bodyType == BodyType.lean) {
        focusTarget = 'Muscle Gain & Strength';
        baseDuration = 15; // Keep duration same
        message = 'We recommend muscle gain workouts focusing on strength training and progressive overload.';
        // Mix: 10% cardio warm-up, 70% strength (hypertrophy), 20% abs
        selectedExercises = [
          ...cardio.take(1),
          ...strength.take(6),
          ...abs.take(1),
          ...stretching.take(1),
        ];
      } else {
        // FIT
        focusTarget = 'Balanced Maintenance';
        baseDuration = 20;
        message = 'We recommend balanced workouts to maintain your athletic physique with a mix of strength and flexibility.';
        // Mix: 20% cardio, 50% strength, 20% abs, 10% stretching
        selectedExercises = [
          ...cardio.take(2),
          ...strength.take(4),
          ...abs.take(2),
          ...stretching.take(2),
        ];
      }
    } else {
      // ── YOGA LOGIC ──
      // Due to the absence of a structured yoga JSON catalogue in context that we can easily query,
      // we will return generic placeholders that the UI can adapt, or we can use the stretching 
      // category from gym exercises as a bridge for yoga.
      final yogaPoses = _allGymExercises.where((e) => e['category'] == 'stretching').toList();
      final fullBody = _allGymExercises.where((e) => e['category'] == 'full_body').toList();
      
      yogaPoses.shuffle();
      fullBody.shuffle();

      if (bodyType == BodyType.fat) {
        focusTarget = 'Dynamic Weight-Loss Yoga';
        baseDuration = 25;
        message = 'We recommend dynamic, fast-paced yoga to elevate heart rate and burn calories.';
        selectedExercises = [
          ...fullBody.take(2),
          ...yogaPoses.take(6),
        ];
      } else if (bodyType == BodyType.lean) {
        focusTarget = 'Strength-Building Yoga';
        baseDuration = 20;
        message = 'We recommend controlled, strength-focused yoga poses to build lean muscle mass.';
        selectedExercises = [
          ...fullBody.take(3),
          ...yogaPoses.take(5),
        ];
      } else {
        focusTarget = 'Flexibility & Balance Yoga';
        baseDuration = 20;
        message = 'We recommend a balanced flow focusing on flexibility, mobility, and breathwork.';
        selectedExercises = [...yogaPoses.take(8)];
      }
    }

    String dietTitle;
    String dietDesc;
    if (bodyType == BodyType.fat) {
      dietTitle = "Calorie Deficit";
      dietDesc = "Target 300-500 kcal deficit daily.\nFocus on high protein, lots of fiber (vegetables), and low carbohydrates to accelerate fat burn.";
    } else if (bodyType == BodyType.lean) {
      dietTitle = "Calorie Surplus";
      dietDesc = "Target 200-400 kcal surplus daily.\nFocus on high protein and complex carbohydrates (oats, brown rice) to build muscle mass.";
    } else {
      dietTitle = "Maintenance";
      dietDesc = "Maintain your current caloric intake.\nBalance macros evenly (e.g., 30% Protein, 40% Carbs, 30% Healthy Fats) to sustain your athletic shape.";
    }

    return SmartWorkoutPlan(
      bodyType: bodyType,
      focusTarget: focusTarget,
      exercises: selectedExercises,
      totalDurationMin: baseDuration,
      message: message,
      dietPlanTitle: dietTitle,
      dietPlanDetails: dietDesc,
    );
  }
}
