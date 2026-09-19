/// Body type from AI analyser
enum BodyTypeCategory { fat, fit, lean }

/// Difficulty level for a gym course
enum CourseLevel { beginner, intermediate, advanced }

/// Single exercise in a course level
class CourseExercise {
  final String name;
  final String? exerciseId;
  final int durationSeconds;

  const CourseExercise({
    required this.name,
    this.exerciseId,
    this.durationSeconds = 30,
  });
}

/// A level within a course (Beginner/Intermediate/Advanced)
class CourseLevelData {
  final CourseLevel level;
  final String goal;
  final List<CourseExercise> exercises;

  const CourseLevelData({
    required this.level,
    required this.goal,
    required this.exercises,
  });

  /// Total duration of all exercises in seconds
  int get totalDurationSeconds =>
      exercises.fold(0, (sum, e) => sum + e.durationSeconds);

  /// Total duration in minutes (rounded up)
  int get totalDurationMinutes => (totalDurationSeconds / 60).ceil();
}

/// A gym course (e.g. Chest Builder, Fat Burn Beast Mode)
class GymCourseInfo {
  final String name;
  final String emoji;
  final String goal;
  final String? bodyType;       // 'fat', 'fit', 'lean', or null for focus-area
  final String? focusArea;      // e.g. 'chest', 'shoulders', or null for body-type
  final String? genderFilter;   // 'male', 'female', or null for common
  final List<CourseLevelData> levels;

  const GymCourseInfo({
    required this.name,
    this.emoji = '💪',
    required this.goal,
    this.bodyType,
    this.focusArea,
    this.genderFilter,
    required this.levels,
  });

  /// Get exercises for a specific level
  CourseLevelData? getLevelData(CourseLevel level) {
    try {
      return levels.firstWhere((l) => l.level == level);
    } catch (_) {
      return levels.isNotEmpty ? levels.first : null;
    }
  }
}
