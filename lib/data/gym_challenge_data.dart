import 'exercise_assets.dart';
import 'gym_user_data.dart';

class GymExercise {
  final String id;
  final String name;
  final String category;
  final List<String> muscleGroup;
  final String difficulty;
  final int durationSeconds;
  final String? animationLottie;
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

  static bool _isAnimationAssetPath(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.lottie') || lower.endsWith('.json');
  }

  static bool _isSupportedAssetFileName(String fileName) {
    final lower = fileName.toLowerCase();
    return lower.endsWith('.lottie') ||
        lower.endsWith('.json') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp');
  }

  static String? _resolveBundledExerciseAsset({
    String? rawPath,
    required String exerciseName,
    String id = '',
  }) {
    final candidates = <String>[];
    final normalizedRawPath = rawPath?.trim() ?? '';

    if (normalizedRawPath.isNotEmpty) {
      if (ExerciseAssets.isKnownExerciseAssetPath(normalizedRawPath)) {
        return normalizedRawPath;
      }

      final fileName = normalizedRawPath.split('/').last;
      final dotIndex = fileName.lastIndexOf('.');
      candidates.add(dotIndex > 0 ? fileName.substring(0, dotIndex) : fileName);
    }

    candidates.add(exerciseName);
    if (id.trim().isNotEmpty) {
      candidates.add(id.replaceAll('_', ' '));
    }

    for (final candidate in candidates) {
      if (candidate.trim().isEmpty) continue;
      final resolved = ExerciseAssets.getAssetForExercise(candidate);
      if (resolved != null) return resolved;
    }

    return null;
  }

  static List<GymExercise> getAllExercises() {
    if (_cachedExercises != null) return _cachedExercises!;

    // Dynamically build metadata from all 255 assets
    final allAssets = ExerciseAssets.allAssets;
    _cachedExercises = allAssets.map((assetName) {
      // Remove extension and clean up string for name
      String rawName = assetName.split('.').first;
      String name = rawName.split(RegExp(r'[-_]')).join(' ').trim();
      // Capitalize first letters
      name = name
          .split(' ')
          .map(
            (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
          )
          .join(' ');

      // Determine category by parsing keywords
      String lower = rawName.toLowerCase();
      String category = 'full_body';
      List<String> muscleGroup = ['full_body'];

      if (lower.contains('push-up') ||
          lower.contains('push up') ||
          lower.contains('chest') ||
          lower.contains('bench press')) {
        category = 'chest';
        muscleGroup = ['chest', 'arms', 'shoulders'];
      } else if (lower.contains('squat') ||
          lower.contains('lunge') ||
          lower.contains('calf') ||
          lower.contains('leg')) {
        category = 'legs';
        muscleGroup = ['legs', 'glutes'];
      } else if (lower.contains('crunch') ||
          lower.contains('plank') ||
          lower.contains('abs') ||
          lower.contains('twist') ||
          lower.contains('bug') ||
          lower.contains('sit up')) {
        category = 'abs';
        muscleGroup = ['abs'];
      } else if (lower.contains('curl') ||
          lower.contains('tricep') ||
          lower.contains('bicep') ||
          lower.contains('dip')) {
        category = 'arms';
        muscleGroup = ['arms', 'biceps', 'triceps'];
      } else if (lower.contains('shoulder') ||
          lower.contains('raise') ||
          lower.contains('press') && !lower.contains('bench')) {
        category = 'shoulders';
        muscleGroup = ['shoulders'];
      } else if (lower.contains('pull up') ||
          lower.contains('row') ||
          lower.contains('back') ||
          lower.contains('superman')) {
        category = 'back';
        muscleGroup = ['back'];
      } else if (lower.contains('glute') ||
          lower.contains('donkey') ||
          lower.contains('bridge') ||
          lower.contains('dog')) {
        category = 'glutes';
        muscleGroup = ['glutes', 'legs'];
      } else if (lower.contains('stretch') ||
          lower.contains('yoga') ||
          lower.contains('pose')) {
        category = 'stretching';
        muscleGroup = ['full_body'];
      } else if (lower.contains('jump') ||
          lower.contains('run') ||
          lower.contains('burpee') ||
          lower.contains('jack') ||
          lower.contains('climber') ||
          lower.contains('skater')) {
        category = 'cardio';
        muscleGroup = ['full_body'];
      }

      String? lottiePath;
      String imagePath = 'assets/images/gym/goal_keep_fit_male.png';

      if (assetName.endsWith('.lottie') || assetName.endsWith('.json')) {
        lottiePath = 'assets/all_exercises/$assetName';
      } else {
        imagePath = 'assets/all_exercises/$assetName';
      }

      return GymExercise(
        id: rawName.toLowerCase().replaceAll(' ', '_'),
        name: name,
        category: category,
        muscleGroup: muscleGroup,
        difficulty: 'intermediate',
        durationSeconds: 30, // Default configurable later
        animationLottie: lottiePath,
        imageAsset: imagePath,
        reps: '10-15',
        instructions: ['Follow the demonstration carefully.'],
        breathingDuration: 20,
        previewDuration: 20,
        performDuration: 30,
        recoveryDuration: 20,
        previewAnimation: lottiePath,
        exerciseAnimation: lottiePath,
      );
    }).toList();

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
    if (cat.contains('butt') || cat.contains('glute')) {
      targets.addAll(['glutes']);
    }
    if (cat.contains('full body') || cat.contains('full_body')) {
      targets.addAll(['full_body']);
    }

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
  static GymExercise mapToGymExercise(Map<String, dynamic> exData) {
    String exName = exData['name'] ?? '';
    String? lottiePath;
    String imagePath = exData['image'] ?? '';
    List<String> instrs =
        (exData['instructions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    int duration = exData['duration'] ?? 30;
    String id = exData['id'] ?? '';
    String category = exData['category'] ?? '';
    List<String> muscleGroup =
        (exData['muscle_group'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    String difficulty = exData['difficulty'] ?? 'beginner';
    String reps = exData['reps']?.toString() ?? ''; // Parse reps

    final resolvedImageAsset = _resolveBundledExerciseAsset(
      rawPath: imagePath,
      exerciseName: exName,
      id: id,
    );
    if (resolvedImageAsset != null) {
      if (_isAnimationAssetPath(resolvedImageAsset)) {
        lottiePath = resolvedImageAsset;
        imagePath = '';
      } else {
        imagePath = resolvedImageAsset;
      }
    }

    // Read animation path from JSON data first
    String? jsonAnimation = exData['animation']?.toString().trim();
    if (jsonAnimation != null && jsonAnimation.isNotEmpty) {
      final resolvedAnimation = _resolveBundledExerciseAsset(
        rawPath: jsonAnimation,
        exerciseName: exName,
        id: id,
      );
      if (resolvedAnimation != null) {
        if (_isAnimationAssetPath(resolvedAnimation)) {
          lottiePath = resolvedAnimation;
        } else {
          imagePath = resolvedAnimation;
        }
      }
    }

    // Fuzzy name-based image matching for exercises not in the explicit map
    // This catches exercises whose names partially match image filenames
    if (lottiePath == null &&
        (imagePath.isEmpty ||
            imagePath.contains('jsonimg') ||
            imagePath.startsWith('assets/images/extraexercises/') ||
            imagePath.startsWith('assets/images/20images/') ||
            (imagePath.startsWith('assets/all_exercises/') &&
                !ExerciseAssets.isKnownExerciseAssetPath(imagePath)))) {
      final fallback = getFallbackImage(exName);
      if (fallback != null) {
        if (_isAnimationAssetPath(fallback)) {
          lottiePath = fallback;
        } else {
          imagePath = fallback;
        }
      }
    }

    // Auto-map animations from assets/all_exercises/ using ExerciseAssets
    if (lottiePath == null) {
      final resolvedPath = ExerciseAssets.getAssetForExercise(exName);
      if (resolvedPath != null) {
        final lowerResolved = resolvedPath.toLowerCase();
        if (lowerResolved.endsWith('.lottie') ||
            lowerResolved.endsWith('.json')) {
          lottiePath = resolvedPath;
        } else {
          // Static image
          imagePath = resolvedPath;
        }
      }
    }

    // Fallback by exercise id for cases where display name has punctuation/noise.
    if (lottiePath == null && id.isNotEmpty) {
      final resolvedById = ExerciseAssets.getAssetForExercise(
        id.replaceAll('_', ' '),
      );
      if (resolvedById != null) {
        final lowerResolved = resolvedById.toLowerCase();
        if (lowerResolved.endsWith('.lottie') ||
            lowerResolved.endsWith('.json')) {
          lottiePath = resolvedById;
        }
      }
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
      if (targetGroups.isEmpty || targetGroups.contains('full_body')) {
        return true;
      }
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
      dailyExercises.insert(
        0,
        const GymExercise(
          name: 'Squats',
          durationSeconds: 30,
          animationLottie: 'assets/all_exercises/squats.lottie',
        ),
      );
      if (dailyExercises.length > 10) dailyExercises.removeLast();
    }

    return dailyExercises;
  }

  /// Global helper to get a bundled fallback asset for exercise thumbnails.
  static String? getFallbackImage(String exerciseName) {
    if (exerciseName.isEmpty) return null;

    final resolved = ExerciseAssets.getAssetForExercise(exerciseName);
    if (resolved != null) {
      return resolved;
    }

    final assets = ExerciseAssets.allAssets
        .where(_isSupportedAssetFileName)
        .toList(growable: false);
    if (assets.isNotEmpty) {
      final index = exerciseName.hashCode.abs() % assets.length;
      return 'assets/all_exercises/${assets[index]}';
    }

    return null;
  }
}
