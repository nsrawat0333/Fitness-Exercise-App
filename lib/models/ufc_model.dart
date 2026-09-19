/// UFC training style
enum UFCStyle { dagestani, irish }

/// Single exercise within a UFC day
class UFCExercise {
  final String name;
  final int sets;
  final String repsOrDuration; // e.g. "15 reps" or "30 sec"

  const UFCExercise({
    required this.name,
    required this.sets,
    required this.repsOrDuration,
  });
}

/// One training day within a UFC course
class UFCDay {
  final int dayNumber;
  final String focus;
  final String emoji;
  final List<UFCExercise> exercises;

  const UFCDay({
    required this.dayNumber,
    required this.focus,
    this.emoji = '🔥',
    required this.exercises,
  });
}

/// A UFC course (e.g. Wrestling Fundamentals)
class UFCCourse {
  final String name;
  final String description;
  final UFCStyle style;
  final String level;
  final String duration;
  final List<UFCDay> days;

  const UFCCourse({
    required this.name,
    required this.description,
    required this.style,
    this.level = 'Beginner → Intermediate',
    this.duration = '2-3 Weeks',
    required this.days,
  });
}
