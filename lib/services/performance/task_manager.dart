import 'dart:async';
import 'package:flutter/foundation.dart';

/// Manages background computation using Flutter Isolates.
/// Prevents heavy operations from blocking the UI thread.
class TaskManager {
  static final TaskManager _instance = TaskManager._internal();
  factory TaskManager() => _instance;
  TaskManager._internal();

  int _activeTasks = 0;
  static const int _maxConcurrentTasks = 3;

  int get activeTasks => _activeTasks;

  /// Run a heavy function off the main thread using `compute`.
  /// Automatically limits concurrent tasks to prevent thread exhaustion.
  ///
  /// [function] must be a top-level or static function.
  /// [param] is the argument passed to the function.
  Future<R> runInBackground<P, R>(
    FutureOr<R> Function(P) function,
    P param, {
    String tag = 'task',
  }) async {
    // Simple throttle: wait if too many tasks are running
    while (_activeTasks >= _maxConcurrentTasks) {
      debugPrint('TaskManager: throttling "$tag" (active=$_activeTasks)');
      await Future.delayed(const Duration(milliseconds: 100));
    }

    _activeTasks++;
    debugPrint('TaskManager: starting "$tag" (active=$_activeTasks)');

    try {
      final result = await compute(function, param);
      return result;
    } catch (e) {
      debugPrint('TaskManager: "$tag" failed: $e');
      rethrow;
    } finally {
      _activeTasks--;
      debugPrint('TaskManager: "$tag" complete (active=$_activeTasks)');
    }
  }

  /// Run a lightweight async operation that doesn't need a full Isolate.
  /// Still tracked for concurrency limits.
  Future<T> runAsync<T>(
    Future<T> Function() function, {
    String tag = 'async_task',
  }) async {
    _activeTasks++;
    try {
      return await function();
    } catch (e) {
      debugPrint('TaskManager: "$tag" failed: $e');
      rethrow;
    } finally {
      _activeTasks--;
    }
  }
}
