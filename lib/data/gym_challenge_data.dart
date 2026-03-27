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
  static List<GymExercise>? _cachedExercises;

  /// Returns ALL exercises parsed from the catalog JSON.
  static List<GymExercise> getAllExercises() {
    if (_cachedExercises != null) return _cachedExercises!;

    final Map<String, dynamic> parsedJson = jsonDecode(gymExercisesJson);
    final List<dynamic> allExercises = parsedJson['exercises'];
    _cachedExercises = allExercises.map((ex) => _mapToGymExercise(ex as Map<String, dynamic>)).toList();
    return _cachedExercises!;
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

    // (extraexercisesAnimation folder removed — using images from extraexercises/ instead)

    // --- EXTRA EXERCISE IMAGE OVERRIDES ---
    // Maps exercise IDs to photos in assets/images/extraexercises/
    const Map<String, String> extraImageOverrides = {
      'decline_push_ups': 'assets/images/extraexercises/Decline Push-Ups.jpg',
      'flutter_kicks': 'assets/images/extraexercises/Flutter kick.jpg',
      'jump_rope': 'assets/images/extraexercises/Jump Rope.jpg',
      'reverse_crunches': 'assets/images/extraexercises/Reverse crunch.jpg',
      'tricep_kickbacks': 'assets/images/extraexercises/Tríceps Pulley.gif',
      'wall_sit': 'assets/images/extraexercises/Wall Sit.jpg',
      'cat_cow_stretch': 'assets/images/extraexercises/cat-cow pose.jpg',
      'chest_press': 'assets/images/extraexercises/chest press.jpg',
      'fire_hydrants': 'assets/images/extraexercises/fire hydril.jpg',
      'lateral_shuffles': 'assets/images/extraexercises/lateral shuffle.jpg',
      'pull_ups': 'assets/images/extraexercises/pullup.jpg',
      'shoulder_press': 'assets/images/extraexercises/sholderpress.jpg',
      'single_leg_glute_bridge': 'assets/images/extraexercises/single leg glute bridge.jpg',
      'skater_jumps': 'assets/images/extraexercises/skater jumps.jpg',
      'step_ups': 'assets/images/extraexercises/step up.jpg',
      'toe_touches': 'assets/images/extraexercises/toe touch.jpg',
      
      // The 20 Images Replacing Heavy Animations
      'back_extension': 'assets/images/20images/back_extension.jpg',
      'sumo_squats': 'assets/images/20images/sumo_squats.jpg',
      'donkey_kicks': 'assets/images/20images/donkey_kicks.jpg',
      'wide_arm_push_up': 'assets/images/20images/wide_arm_push_up.jpg',
      'hammer_curl': 'assets/images/20images/hammer_curl.jpg',
      'bicep_curl': 'assets/images/20images/bicep_curl.jpg',
      'kettlebell_swings': 'assets/images/20images/kettlebell_swings.jpg',
      'russian_twist': 'assets/images/20images/russian_twist.jpg',
      'dumbbell_lunges': 'assets/images/20images/dumbbell_lunges.jpg',
      'dead_bug': 'assets/images/20images/dead_bug.jpg',
      'reverse_fly': 'assets/images/20images/reverse_fly.jpg',
      'plank': 'assets/images/20images/plank.jpg',
      'hamstring_stretch': 'assets/images/20images/hamstring_stretch.jpg',
      'diamond_push_up': 'assets/images/20images/diamond_push_up.jpg',
      'arnold_press': 'assets/images/20images/arnold_press.jpg',
      'leg_raises': 'assets/images/20images/leg_raises.jpg',
      'deadlift': 'assets/images/20images/deadlift.jpg',
      'skull_crushers': 'assets/images/20images/skull_crushers.jpg',
      'arm_circle': 'assets/images/20images/arm_circle.jpg',
      'decline_push_up': 'assets/images/20images/decline_push_up.jpg',
    };

    if (extraImageOverrides.containsKey(id.toLowerCase())) {
      imagePath = extraImageOverrides[id.toLowerCase()]!;
    }

    // Fuzzy name-based image matching for exercises not in the explicit map
    // This catches exercises whose names partially match image filenames  
    if (imagePath.isEmpty || imagePath.contains('jsonimg')) {
      final fallback = getFallbackImage(exName);
      if (fallback != null) {
        imagePath = fallback;
      }
    }

    // Comprehensive Lottie animation auto-mapping from assets/images/jsonanimation/
    if (lottiePath == null) {
      const basePath = 'assets/images/jsonanimation/';
      final nameKey = exName.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');

      // Full mapping table: exercise name keywords → animation file
      const Map<String, String> animationMap = {
        'jumping_jacks': 'animationjumpingjaks.json',
        'push_up': 'push_up.json',
        'push_ups': 'push_up.json',
        'pushup': 'push_up.json',
        'pull_up': 'pull_up.json',
        'pull_ups': 'pull_up.json',
        'squat': 'sumo_squats.json',
        'squats': 'sumo_squats.json',
        'jump_squats': 'jump_squats.json',
        'pistol_squats': 'pistol_squats.json',
        'lunges': 'Lunges.json',
        'walking_lunges': 'walking_lunges.json',
        'side_lunges': 'side_lunges.json',
        'bench_press': 'bench_press.json',
        'concentration_curls': 'concentration_curls.json',
        'calf_raises': 'calf_rasies.json',
        'side_plank': 'Side Plank.json',
        'plank_jacks': 'Plank Jacks.json',
        'mountain_climber': 'mountain climber.json',
        'mountain_climbers': 'mountain climber.json',
        'burpees': 'Box jump.json',
        'box_jump': 'Box jump.json',
        'box_jumps': 'Box jump.json',
        'dead_lift': 'DeadLift.json',
        'bicycle_crunches': 'bicycle Crunches.json',
        'sit_ups': 'situps.json',
        'situps': 'situps.json',
        'v_ups': 'v_up.json',
        'v_up': 'v_up.json',
        'heel_touch': 'Heel Touch.json',
        'heel_touches': 'Heel Touch.json',
        'dead_bug': 'dead_bug.json',
        'back_extension': 'back_extension.json',
        'back_extensions': 'back_extension.json',
        'lat_pull_down': 'lat_pull_down.json',
        'lat_pulldown': 'lat_pull_down.json',
        'tricep_dips': 'Tricep Dips.json',
        'dips': 'Tricep Dips.json',
        'chest_dips': 'chest dips.json',
        'diamond_push_up': 'diamond_push_up.json',
        'diamond_push_ups': 'diamond_push_up.json',
        'close_grip_push_ups': 'close_grip_push_ups.json',
        'decline_push_up': 'Decline push up.json',
        'pike_push_ups': 'Pike push ups.json',
        'wide_arm_push_up': 'wide Arm push up.json',
        'wide_push_up': 'wide Arm push up.json',
        'arnold_press': 'Arnold Press.json',
        'shoulder_press': 'Arnold Press.json',
        'face_pulls': 'face_pulls.json',
        'reverse_fly': 'Reverse Fly.json',
        'shrug': 'shrug.json',
        'shrugs': 'shrug.json',
        'renegade_rows': 'Renegade Rows.json',
        'bent_over_rows': 'Bent Over Rows Band.json',
        'chest_fly': 'Chest fly.json',
        'kettlebell_swings': 'Kettlebell Swings.json',
        'farmer_walk': "Farmer's Walk.json",
        "farmer's_walk": "Farmer's Walk.json",
        'skull_crushers': 'skull_crushers.json',
        'overhead_tricep_extension': 'overhead tricep extention.json',
        'glute_bridge': 'Glute Bridge.json',
        'hip_thrusts': 'Hip Thrusts.json',
        'donkey_kicks': 'Donkey Kicks.json',
        'froggy_glute_lifts': 'froggy Glute lifts.json',
        'froggy_glute_lift': 'froggy Glute lifts.json',
        'cobra_stretch': 'Cobra Stretch.json',
        'downward_dog': 'downward dog.json',
        'cat_cow': 'cat_cow_pose.json',
        'cat_cow_pose': 'cat_cow_pose.json',
        'hip_flexor_stretch': 'Hip Flexor Stretch.json',
        'quad_stretch': 'Quad Stretch.json',
        'shoulder_stretch': 'Shoulder Stretch.json',
        'pigeon_stretch': 'Pigeon Stretch.json',
        'hamstring_stretch': 'hamstringstrech.json',
        'arm_circle': 'arm_circle.json',
        'arm_circles': 'arm_circle.json',
        'chin_ups': 'Chin ups.json',
      };

      // Direct key match
      if (animationMap.containsKey(nameKey)) {
        lottiePath = '$basePath${animationMap[nameKey]}';
      } else {
        // Fuzzy match: check if any key is contained in the exercise name
        for (final entry in animationMap.entries) {
          if (nameKey.contains(entry.key) || entry.key.contains(nameKey)) {
            lottiePath = '$basePath${entry.value}';
            break;
          }
        }
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
    final allExercises = getAllExercises();

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

    List<GymExercise> filtered = allExercises.where((ex) {
      if (targetGroups.isEmpty || targetGroups.contains('full_body')) return true;
      for (var mg in ex.muscleGroup) {
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
      dailyExercises.add(filtered[index]);
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

  /// Global helper to get fallback images from extraexercises based on partial name match
  static String? getFallbackImage(String exerciseName) {
    if (exerciseName.isEmpty) return null;
    final nameL = exerciseName.toLowerCase();
    const Map<String, String> fuzzyImageMap = {
      'child pose': 'assets/images/extraexercises/Child Pose Yoga.jpg',
      'decline push': 'assets/images/extraexercises/Decline Push-Ups.jpg',
      'flutter kick': 'assets/images/extraexercises/Flutter kick.jpg',
      'jump rope': 'assets/images/extraexercises/Jump Rope.jpg',
      'plank': 'assets/images/extraexercises/Plank.jpg',
      'reverse crunch': 'assets/images/extraexercises/Reverse crunch.jpg',
      'pulley': 'assets/images/extraexercises/Tríceps Pulley.gif',
      'triceps pulley': 'assets/images/extraexercises/Tríceps Pulley.gif',
      'wall sit': 'assets/images/extraexercises/Wall Sit.jpg',
      'wrist': 'assets/images/extraexercises/barball wrist carl.jpg',
      'bear crawl': 'assets/images/extraexercises/bear crawl.jpg',
      'cat-cow': 'assets/images/extraexercises/cat-cow pose.jpg',
      'cat cow': 'assets/images/extraexercises/cat-cow pose.jpg',
      'chest press': 'assets/images/extraexercises/chest press.jpg',
      'fire hydrant': 'assets/images/extraexercises/fire hydril.jpg',
      'front raise': 'assets/images/extraexercises/front raise.jpg',
      'good morning': 'assets/images/extraexercises/good morning.jpg',
      'inchworm': 'assets/images/extraexercises/incworms.jpg',
      'inverted row': 'assets/images/extraexercises/inverted rows.jpg',
      'lateral shuffle': 'assets/images/extraexercises/lateral shuffle.jpg',
      'lateral raise': 'assets/images/extraexercises/leteral raise.jpg',
      'man maker': 'assets/images/extraexercises/man makers.jpg',
      'pull-up': 'assets/images/extraexercises/pullup.jpg',
      'pull up': 'assets/images/extraexercises/pullup.jpg',
      'pullup': 'assets/images/extraexercises/pullup.jpg',
      'shoulder press': 'assets/images/extraexercises/sholderpress.jpg',
      'single leg glute': 'assets/images/extraexercises/single leg glute bridge.jpg',
      'skater jump': 'assets/images/extraexercises/skater jumps.jpg',
      'step-up': 'assets/images/extraexercises/step up.jpg',
      'step up': 'assets/images/extraexercises/step up.jpg',
      'superman': 'assets/images/extraexercises/superman.jpg',
      'thruster': 'assets/images/extraexercises/thruster.jpg',
      'toe touch': 'assets/images/extraexercises/toe touch.jpg',
      'tricep kickback': 'assets/images/extraexercises/tricep kickback.jpg',
      'turkish get': 'assets/images/extraexercises/turkish getup.jpg',
    };
    
    for (final entry in fuzzyImageMap.entries) {
      if (nameL.contains(entry.key)) {
         return entry.value;
      }
    }
    
    // If no match found, pick a consistent image from the list so no exercise is empty
    final values = fuzzyImageMap.values.toSet().toList();
    if (values.isNotEmpty) {
      final index = exerciseName.hashCode.abs() % values.length;
      return values[index];
    }
    
    return null;
  }
}
