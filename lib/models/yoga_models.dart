// Data models for the Yoga module.

/// Represents a single yoga pose.
class YogaPose {
  final String name;
  final String sanskritName;
  final String description;
  final List<String> steps;
  final int durationSeconds;
  final String category; // 'warmup', 'strength', 'flexibility', 'relaxation'
  final List<String> focusAreas; // e.g., ['weight_loss', 'flexibility']
  final String image;
  final String animation;

  const YogaPose({
    required this.name,
    required this.sanskritName,
    required this.description,
    this.steps = const [],
    this.durationSeconds = 60,
    this.category = 'warmup',
    this.focusAreas = const [],
    this.image = '',
    this.animation = '',
  });
}

/// A single day in the 30-day yoga program.
class YogaDay {
  final int dayNumber;
  final String title;
  final String duration;
  final String focus;
  final String phase; // 'Beginner', 'Foundation', 'Intermediate', 'Advanced'
  final List<YogaPose> poses;
  final bool isRestDay;

  const YogaDay({
    required this.dayNumber,
    required this.title,
    this.duration = '15 min',
    this.focus = 'Relax + Flexibility',
    this.phase = 'Beginner',
    this.poses = const [],
    this.isRestDay = false,
  });
}

/// A yoga session for a specific focus area.
class YogaSession {
  final String title;
  final String duration;
  final String focusArea;
  final String difficulty;
  final List<YogaPose> poses;

  const YogaSession({
    required this.title,
    required this.duration,
    required this.focusArea,
    this.difficulty = 'All Levels',
    this.poses = const [],
  });
}

/// Diet plan for a specific goal.
class YogaDietPlan {
  final String goal;
  final String morning;
  final String breakfast;
  final String lunch;
  final String evening;
  final String dinner;

  const YogaDietPlan({
    required this.goal,
    required this.morning,
    required this.breakfast,
    required this.lunch,
    required this.evening,
    required this.dinner,
  });
}
