// Data models for the Home Workout system.

class HomeExercise {
  final String name;
  final String description;
  final List<String> steps;
  final String duration;
  final String reps;
  final String rest;
  final String image;
  final String animation;

  const HomeExercise({
    required this.name,
    required this.description,
    this.steps = const [],
    this.duration = '30s',
    this.reps = '10-12',
    this.rest = '30s',
    this.image = '',
    this.animation = '',
  });

  /// Creates a copy with adjusted intensity for progressive overload.
  HomeExercise withProgression({
    required double repsMultiplier,
    required int restReductionSeconds,
  }) {
    // Parse reps string and multiply
    String newReps = reps;
    final repsMatch = RegExp(r'(\d+)-(\d+)').firstMatch(reps);
    if (repsMatch != null) {
      int low = (int.parse(repsMatch.group(1)!) * repsMultiplier).round();
      int high = (int.parse(repsMatch.group(2)!) * repsMultiplier).round();
      newReps = '$low-$high';
    } else if (reps != 'hold') {
      final singleMatch = RegExp(r'(\d+)').firstMatch(reps);
      if (singleMatch != null) {
        int val = (int.parse(singleMatch.group(1)!) * repsMultiplier).round();
        newReps = '$val';
      }
    }

    // Parse rest and reduce
    String newRest = rest;
    final restMatch = RegExp(r'(\d+)').firstMatch(rest);
    if (restMatch != null) {
      int restSec = int.parse(restMatch.group(1)!);
      restSec = (restSec - restReductionSeconds).clamp(10, 120);
      newRest = '${restSec}s';
    }

    return HomeExercise(
      name: name,
      description: description,
      steps: steps,
      duration: duration,
      reps: newReps,
      rest: newRest,
      image: image,
      animation: animation,
    );
  }

  factory HomeExercise.fromJson(Map<String, dynamic> json) {
    return HomeExercise(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      steps: (json['steps'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      duration: json['duration'] ?? '30s',
      reps: json['reps'] ?? '10-12',
      rest: json['rest'] ?? '30s',
      image: json['image'] ?? '',
      animation: json['animation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'steps': steps,
    'duration': duration,
    'reps': reps,
    'rest': rest,
    'image': image,
    'animation': animation,
  };
}

class HomeWorkoutDay {
  final int dayNumber;
  final String title;
  final List<HomeExercise> exercises;
  final bool isRestDay;
  final int estimatedMinutes;

  const HomeWorkoutDay({
    required this.dayNumber,
    required this.title,
    this.exercises = const [],
    this.isRestDay = false,
    this.estimatedMinutes = 20,
  });
}

class HomeWorkoutWeek {
  final int weekNumber;
  final String theme;
  final List<HomeWorkoutDay> days;
  final String difficultyLabel;

  const HomeWorkoutWeek({
    required this.weekNumber,
    required this.theme,
    required this.days,
    this.difficultyLabel = 'Moderate',
  });

  int get totalExercises {
    return days.fold(0, (sum, day) => sum + day.exercises.length);
  }

  int get restDays {
    return days.where((d) => d.isRestDay).length;
  }
}

class HomeWorkoutProgram {
  final String focusArea;
  final String level;
  final String goal;
  final int totalWeeks;
  final List<HomeWorkoutWeek> weeks;

  const HomeWorkoutProgram({
    required this.focusArea,
    required this.level,
    required this.goal,
    required this.totalWeeks,
    required this.weeks,
  });

  int get totalDays => weeks.fold(0, (sum, w) => sum + w.days.length);
  int get totalRestDays => weeks.fold(0, (sum, w) => sum + w.restDays);
  int get totalWorkoutDays => totalDays - totalRestDays;
}
