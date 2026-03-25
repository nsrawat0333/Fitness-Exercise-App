import 'dart:convert';
import 'gym_exercises_catalog.dart';
import 'gym_user_data.dart';

class GymExercise {
  final String id;
  final String name;
  final String category;
  final List<String> muscleGroup;
  final String difficulty;
  final int durationSeconds;
  final String? animationLottie;
  final String? videoAsset;
  final String? imageAsset;
  final List<String> instructions;
  final String reps; // Added reps field

  // ── 5-Phase Workout Flow Fields ──
  final int breathingDuration;
  final int previewDuration;
  final int performDuration;
  final int recoveryDuration;
  final String? breathingAnimation;
  final String? previewAnimation;
  final String? exerciseAnimation;
  
  const GymExercise({
    this.id = '',
    required this.name,
    this.category = '',
    this.muscleGroup = const [],
    this.difficulty = 'beginner',
    this.durationSeconds = 30,
    this.animationLottie,
    this.videoAsset,
    this.imageAsset,
    this.instructions = const [],
    this.reps = '', // Default to empty string for reps
    this.breathingDuration = 20,
    this.previewDuration = 20,
    this.performDuration = 30,
    this.recoveryDuration = 20,
    this.breathingAnimation,
    this.previewAnimation,
    this.exerciseAnimation,
  });

  /// Phase durations map for the workout flow controller.
  Map<String, int> get phaseDurations => {
    'breathing': breathingDuration,
    'preview': previewDuration,
    'perform': performDuration,
    'recovery': recoveryDuration,
  };
}

class GymChallengeData {

  /// Returns ALL exercises parsed from the catalog JSON.
  static List<GymExercise> getAllExercises() {
    final Map<String, dynamic> parsedJson = jsonDecode(gymExercisesJson);
    final List<dynamic> allExercises = parsedJson['exercises'];
    return allExercises.map((ex) => _mapToGymExercise(ex)).toList();
  }

  /// Returns exercises filtered by a specific category/body part.
  static List<GymExercise> getExercisesByCategory(String category) {
    final all = getAllExercises();
    final cat = category.toLowerCase();

    // Map UI tab names to exercise categories/muscle_groups
    List<String> targets = [];
    if (cat.contains('abs')) targets.addAll(['abs']);
    if (cat.contains('arm')) targets.addAll(['arms', 'biceps', 'triceps']);
    if (cat.contains('biceps')) targets.addAll(['biceps', 'arms']);
    if (cat.contains('triceps')) targets.addAll(['triceps', 'arms']);
    if (cat.contains('chest')) targets.addAll(['chest']);
    if (cat.contains('leg')) targets.addAll(['legs', 'calves', 'glutes']);
    if (cat.contains('shoulder')) targets.addAll(['shoulders']);
    if (cat.contains('back')) targets.addAll(['back']);
    if (cat.contains('butt') || cat.contains('glute')) targets.addAll(['glutes']);
    if (cat.contains('full body') || cat.contains('full_body')) targets.addAll(['full_body']);

    if (targets.isEmpty || targets.contains('full_body')) return all;

    return all.where((ex) {
      // Check category match
      if (targets.contains(ex.category)) return true;
      // Check muscle group match
      for (var mg in ex.muscleGroup) {
        if (targets.contains(mg)) return true;
      }
      return false;
    }).toList();
  }

  /// Search exercises by name query.
  static List<GymExercise> searchExercises(String query) {
    if (query.trim().isEmpty) return [];
    final all = getAllExercises();
    final q = query.toLowerCase();
    return all.where((ex) => ex.name.toLowerCase().contains(q)).toList();
  }

  /// Total plan days for the user's activity level.
  static int getTotalDaysForDifficulty() {
    return GymUserData().totalPlanDays;
  }

  /// Map raw JSON to GymExercise with Lottie/video overrides.
  static GymExercise _mapToGymExercise(Map<String, dynamic> exData) {
    String exName = exData['name'] ?? '';
    String? lottiePath;
    String? videoPath;
    String imagePath = exData['image'] ?? '';
    List<String> instrs = (exData['instructions'] as List<dynamic>?)
        ?.map((e) => e.toString()).toList() ?? [];
    int duration = exData['duration'] ?? 30;
    String id = exData['id'] ?? '';
    String category = exData['category'] ?? '';
    List<String> muscleGroup = (exData['muscle_group'] as List<dynamic>?)
        ?.map((e) => e.toString()).toList() ?? [];
    String difficulty = exData['difficulty'] ?? 'beginner';
    String reps = exData['reps']?.toString() ?? ''; // Parse reps

    // Read animation path from JSON data first
    String? jsonAnimation = exData['animation']?.toString();
    if (jsonAnimation != null && jsonAnimation.isNotEmpty) {
      lottiePath = jsonAnimation;
    }

    // Fallback Lottie overrides for exercises without animation in JSON
    if (lottiePath == null) {
      if (exName == 'Jumping Jacks') {
        lottiePath = 'assets/images/jsonanimation/animationjumpingjaks.json';
      } else if (exName.toLowerCase().contains('squat')) {
        lottiePath = 'assets/images/jsonanimation/sqautss.json';
      } else if (exName.toLowerCase().contains('froggy glute lift')) {
        lottiePath = 'assets/images/jsonanimation/froggy Glute Lifts.json';
      }
    }

    // Video overrides
    if (exName.toLowerCase().contains('push')) {
      videoPath = 'assets/images/mp4videofolder/pushup.mp4';
    }

    // Difficulty-based phase duration adjustments
    int breathingDur = 20;
    int previewDur = 20;
    int performDur = duration;
    int recoveryDur = 20;

    final userLevel = GymUserData().activity.toLowerCase();
    if (userLevel == 'beginner') {
      breathingDur = 25;
      previewDur = 20;
      recoveryDur = 25;
    } else if (userLevel == 'advanced') {
      breathingDur = 15;
      previewDur = 15;
      performDur = (duration * 1.5).round();
      recoveryDur = 15;
    }

    return GymExercise(
      id: id,
      name: exName,
      category: category,
      muscleGroup: muscleGroup,
      difficulty: difficulty,
      durationSeconds: duration,
      animationLottie: lottiePath,
      videoAsset: videoPath,
      imageAsset: imagePath,
      instructions: instrs,
      breathingDuration: breathingDur,
      previewDuration: previewDur,
      performDuration: performDur,
      recoveryDuration: recoveryDur,
      breathingAnimation: null, // Configurable: set Lottie path when available
      previewAnimation: lottiePath, // Reuse exercise animation for preview
      exerciseAnimation: lottiePath,
      reps: reps, // Include reps in the returned map
    );
  }

  static List<GymExercise> getExercisesForDay(int overallDayIndex) {
    final Map<String, dynamic> parsedJson = jsonDecode(gymExercisesJson);
    final List<dynamic> allExercises = parsedJson['exercises'];

    String focus = GymUserData().focusArea.toLowerCase();
    List<String> targetGroups = [];
    if (focus.contains('abs')) targetGroups.add('abs');
    if (focus.contains('arm')) targetGroups.add('arms');
    if (focus.contains('chest')) targetGroups.add('chest');
    if (focus.contains('leg')) targetGroups.add('legs');
    if (focus.contains('shoulder')) targetGroups.add('shoulders');
    if (focus.contains('back')) targetGroups.add('back');
    if (focus.contains('butt')) targetGroups.add('glutes');
    if (focus.contains('full body')) targetGroups.add('full_body');

    List<dynamic> filtered = allExercises.where((ex) {
      if (targetGroups.isEmpty || targetGroups.contains('full_body')) return true;
      List<dynamic> muscles = ex['muscle_group'] as List<dynamic>;
      for (var mg in muscles) {
        if (targetGroups.contains(mg)) return true;
      }
      return false;
    }).toList();

    if (filtered.isEmpty) filtered = allExercises;

    List<GymExercise> dailyExercises = [];
    int poolSize = filtered.length;
    int startIndex = (overallDayIndex * 5) % poolSize;
    
    for (int i = 0; i < 10; i++) {
      int index = (startIndex + i * 3) % poolSize;
      dailyExercises.add(_mapToGymExercise(filtered[index]));
    }
    
    if (overallDayIndex == 1 && focus.contains('full body')) {
      dailyExercises.insert(0, const GymExercise(
        name: 'Squats',
        durationSeconds: 30,
        animationLottie: 'assets/images/jsonanimation/sqautss.json',
      ));
      if (dailyExercises.length > 10) dailyExercises.removeLast();
    }
    
    return dailyExercises;
  }
}
