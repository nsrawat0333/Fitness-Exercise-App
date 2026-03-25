class PlannerTask {
  final String id;
  final String title;
  final String category;
  double targetReps;
  double targetSets;
  bool isCompleted;

  PlannerTask({
    required this.id,
    required this.title,
    required this.category,
    required this.targetReps,
    required this.targetSets,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'targetReps': targetReps,
      'targetSets': targetSets,
      'isCompleted': isCompleted,
    };
  }

  factory PlannerTask.fromMap(Map<String, dynamic> map) {
    return PlannerTask(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      targetReps: map['targetReps'].toDouble(),
      targetSets: map['targetSets'].toDouble(),
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

class WorkoutLog {
  final String taskId;
  final String date;
  final double reps;
  final double sets;

  WorkoutLog({
    required this.taskId,
    required this.date,
    required this.reps,
    required this.sets,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'date': date,
      'reps': reps,
      'sets': sets,
    };
  }

  factory WorkoutLog.fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      taskId: map['taskId'],
      date: map['date'],
      reps: map['reps'].toDouble(),
      sets: map['sets'].toDouble(),
    );
  }
}
