import 'package:flutter/foundation.dart';
import '../models/planner_models.dart';
import 'planner_ml_service.dart';

class PlannerStateService extends ChangeNotifier {
  // Mode can be 'gym' or 'yoga'
  String _currentMode = 'gym';
  
  // Simulated database for the current week's plan (Monday=1 ... Sunday=7)
  final Map<int, List<PlannerTask>> _weeklyPlan = {};
  
  // Tracking history
  final List<WorkoutLog> _workoutLogs = [];
  
  int _consecutiveDaysLogged = 0;

  PlannerStateService() {
    _initDefaultPlan();
  }

  String get currentMode => _currentMode;
  List<PlannerTask> getTasksForDay(int weekday) => _weeklyPlan[weekday] ?? [];

  void setMode(String mode) {
    if (_currentMode != mode) {
      _currentMode = mode;
      _initDefaultPlan();
      notifyListeners();
    }
  }

  void _initDefaultPlan() {
    _weeklyPlan.clear();
    if (_currentMode == 'gym') {
      _weeklyPlan[1] = [ // Monday: Chest
        PlannerTask(id: 'g1', title: 'Bench Press', category: 'Chest', targetReps: 10, targetSets: 3),
        PlannerTask(id: 'g2', title: 'Incline Dumbbell Press', category: 'Chest', targetReps: 12, targetSets: 3),
      ];
      _weeklyPlan[2] = [ // Tuesday: Back
        PlannerTask(id: 'g3', title: 'Pull-ups', category: 'Back', targetReps: 8, targetSets: 3),
        PlannerTask(id: 'g4', title: 'Barbell Rows', category: 'Back', targetReps: 12, targetSets: 3),
      ];
      _weeklyPlan[3] = [ // Wednesday: Legs
        PlannerTask(id: 'g5', title: 'Squats', category: 'Legs', targetReps: 10, targetSets: 4),
        PlannerTask(id: 'g6', title: 'Leg Extensions', category: 'Legs', targetReps: 15, targetSets: 3),
      ];
      _weeklyPlan[4] = [ // Thursday: Shoulders
        PlannerTask(id: 'g7', title: 'Overhead Press', category: 'Shoulders', targetReps: 10, targetSets: 3),
        PlannerTask(id: 'g8', title: 'Lateral Raises', category: 'Shoulders', targetReps: 15, targetSets: 3),
      ];
      _weeklyPlan[5] = [ // Friday: Arms
        PlannerTask(id: 'g9', title: 'Bicep Curls', category: 'Arms', targetReps: 12, targetSets: 3),
        PlannerTask(id: 'g10', title: 'Tricep Dips', category: 'Arms', targetReps: 12, targetSets: 3),
      ];
      _weeklyPlan[6] = [ // Saturday: Full Body/Cardio
        PlannerTask(id: 'g11', title: 'Treadmill Run', category: 'Cardio', targetReps: 20, targetSets: 1), // 20 mins
        PlannerTask(id: 'g12', title: 'Burpees', category: 'Full Body', targetReps: 15, targetSets: 3),
      ];
      _weeklyPlan[7] = []; // Sunday: Rest
    } else {
      _weeklyPlan[1] = [ // Monday: Flexibility
        PlannerTask(id: 'y1', title: 'Downward Dog', category: 'Flexibility', targetReps: 60, targetSets: 1), // seconds
        PlannerTask(id: 'y2', title: 'Child\'s Pose', category: 'Flexibility', targetReps: 60, targetSets: 1),
      ];
      _weeklyPlan[2] = [ // Tuesday: Core
        PlannerTask(id: 'y3', title: 'Boat Pose', category: 'Core', targetReps: 30, targetSets: 3),
        PlannerTask(id: 'y4', title: 'Plank', category: 'Core', targetReps: 60, targetSets: 1),
      ];
      _weeklyPlan[3] = [ // Wednesday: Relaxation
        PlannerTask(id: 'y5', title: 'Corpse Pose (Savasana)', category: 'Relaxation', targetReps: 300, targetSets: 1),
      ];
      _weeklyPlan[4] = [ // Thursday: Strength Yoga
        PlannerTask(id: 'y6', title: 'Warrior I', category: 'Strength', targetReps: 45, targetSets: 2),
        PlannerTask(id: 'y7', title: 'Warrior II', category: 'Strength', targetReps: 45, targetSets: 2),
      ];
      _weeklyPlan[5] = [ // Friday: Balance
        PlannerTask(id: 'y8', title: 'Tree Pose', category: 'Balance', targetReps: 60, targetSets: 2),
        PlannerTask(id: 'y9', title: 'Eagle Pose', category: 'Balance', targetReps: 45, targetSets: 2),
      ];
      _weeklyPlan[6] = [ // Saturday: Full Body Flow
        PlannerTask(id: 'y10', title: 'Surya Namaskar', category: 'Flow', targetReps: 10, targetSets: 1), // cycles
      ];
      _weeklyPlan[7] = [ // Sunday: Meditation
        PlannerTask(id: 'y11', title: 'Seated Meditation', category: 'Meditation', targetReps: 600, targetSets: 1),
      ];
    }
  }

  Future<void> toggleTaskCompletion(int weekday, String taskId) async {
    final tasks = _weeklyPlan[weekday];
    if (tasks == null) return;

    for (var task in tasks) {
      if (task.id == taskId) {
        task.isCompleted = !task.isCompleted;
        if (task.isCompleted) {
          _workoutLogs.add(WorkoutLog(
            taskId: taskId,
            date: DateTime.now().toIso8601String(),
            reps: task.targetReps,
            sets: task.targetSets,
          ));
          _consecutiveDaysLogged++;
          
          // Trigger ML prediction for next time
          _applyProgressiveOverload(task);
        } else {
          // If unchecked, remove the log (simulated)
          _workoutLogs.removeWhere((l) => l.taskId == taskId);
          if (_consecutiveDaysLogged > 0) _consecutiveDaysLogged--;
        }
        notifyListeners();
        break;
      }
    }
  }

  Future<void> _applyProgressiveOverload(PlannerTask completedTask) async {
    final mlService = PlannerMLService();
    try {
      final prediction = await mlService.predictNextTargets(
        currentReps: completedTask.targetReps,
        currentSets: completedTask.targetSets,
        consecutiveDaysLogged: _consecutiveDaysLogged.toDouble(),
      );
      
      // We internally update the target reps of the same task for the next rotation
      // In a real DB, we'd spawn a new task for next week.
      completedTask.targetReps = prediction['reps']!;
      completedTask.targetSets = prediction['sets']!;
      debugPrint("ML Progressive Overload Applied: -> ${completedTask.targetReps} reps, ${completedTask.targetSets} sets");
    } catch (e) {
      debugPrint("Failed to apply ML overload: $e");
    }
  }

  void addTask(int weekday, PlannerTask newTask) {
    if (_weeklyPlan[weekday] == null) {
      _weeklyPlan[weekday] = [];
    }
    _weeklyPlan[weekday]!.add(newTask);
    notifyListeners();
  }

  void removeTask(int weekday, String taskId) {
    _weeklyPlan[weekday]?.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }
}
