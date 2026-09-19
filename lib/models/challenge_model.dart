/// Challenge exercise types
enum ChallengeExerciseType { rep, time, speed }

/// Single exercise within a challenge
class ChallengeExercise {
  final String name;
  final String exerciseId;
  final ChallengeExerciseType type;
  final int targetReps;      // for rep-based
  final int targetSeconds;   // for time/speed-based
  final String? imageAsset;

  const ChallengeExercise({
    required this.name,
    required this.exerciseId,
    this.type = ChallengeExerciseType.rep,
    this.targetReps = 10,
    this.targetSeconds = 30,
    this.imageAsset,
  });
}

/// One challenge level (e.g. Junior Trainee = 10 exercises)
class ChallengeLevel {
  final int exerciseCount;
  final String name;
  final String tagline;
  final String auraColor;    // hex color for UI
  final List<ChallengeExercise> exercises;

  const ChallengeLevel({
    required this.exerciseCount,
    required this.name,
    required this.tagline,
    required this.auraColor,
    required this.exercises,
  });
}
