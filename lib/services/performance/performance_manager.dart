import 'package:flutter/foundation.dart';
import 'device_profiler.dart';
import 'memory_manager.dart';
import 'animation_manager.dart';
import 'task_manager.dart';

/// Central performance coordinator.
/// Initializes all sub-managers in the correct order and provides
/// a single entry point for the app to access performance features.
///
/// Usage: `await PerformanceManager().init();` in main() before runApp().
class PerformanceManager {
  static final PerformanceManager _instance = PerformanceManager._internal();
  factory PerformanceManager() => _instance;
  PerformanceManager._internal();

  bool _initialized = false;

  // Sub-managers (access via PerformanceManager for convenience)
  final DeviceProfiler deviceProfiler = DeviceProfiler();
  final MemoryManager memoryManager = MemoryManager();
  final AnimationManager animationManager = AnimationManager();
  final TaskManager taskManager = TaskManager();

  /// Initialize the full performance pipeline.
  /// Call this once from main() AFTER WidgetsFlutterBinding.ensureInitialized().
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final stopwatch = Stopwatch()..start();

    // 1. Profile the device first (everything else depends on this)
    await deviceProfiler.init();

    // 2. Configure memory limits based on device tier
    memoryManager.init();

    // 3. Configure animation behaviour
    animationManager.init();

    // 4. TaskManager is lazy — no init needed

    stopwatch.stop();
    debugPrint(
      'PerformanceManager: init complete in ${stopwatch.elapsedMilliseconds}ms',
    );
    debugPrint('PerformanceManager: device=${deviceProfiler.summary}');
  }

  /// Clear caches before entering a memory-heavy screen.
  void prepareForHeavyScreen() {
    memoryManager.clearImageCache();
  }

  /// Print full diagnostics.
  void printDiagnostics() {
    debugPrint('=== PerformanceManager Diagnostics ===');
    debugPrint('Device: ${deviceProfiler.summary}');
    debugPrint('ImageCache: ${memoryManager.cacheStats}');
    debugPrint('Animations: enabled=${animationManager.animationsEnabled}');
    debugPrint('Tasks: active=${taskManager.activeTasks}');

    debugPrint('======================================');
  }

  void dispose() {}
}
