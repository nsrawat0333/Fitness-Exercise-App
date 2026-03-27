import 'package:flutter/foundation.dart';
import '../tflite_service_mobile.dart';
import '../pose_detection_service.dart';

/// Ensures ML models are loaded exactly once and reused globally.
/// Prevents repeated model loading which causes severe lag spikes.
class MLManager {
  static final MLManager _instance = MLManager._internal();
  factory MLManager() => _instance;
  MLManager._internal();

  bool _tfliteReady = false;
  bool _poseReady = false;

  bool get isTFLiteReady => _tfliteReady;
  bool get isPoseReady => _poseReady;

  /// Pre-load the TFLite body scan model in the background.
  /// Call this during splash screen so it's ready when needed.
  Future<void> warmUpTFLite() async {
    if (_tfliteReady) return;
    try {
      await TFLiteService().initialize();
      _tfliteReady = true;
      debugPrint('MLManager: TFLite model warmed up');
    } catch (e) {
      debugPrint('MLManager: TFLite warm-up failed: $e');
    }
  }

  /// Mark the Pose Detection pipeline as ready.
  /// PoseDetectionService initializes its PoseDetector inline via the
  /// singleton constructor, so no explicit init() call is needed.
  void warmUpPoseDetection() {
    if (_poseReady) return;
    try {
      // Access the singleton to trigger lazy construction
      PoseDetectionService();
      _poseReady = true;
      debugPrint('MLManager: PoseDetection warmed up');
    } catch (e) {
      debugPrint('MLManager: PoseDetection warm-up failed: $e');
    }
  }

  /// Release all ML resources to free memory.
  void releaseAll() {
    PoseDetectionService().dispose();
    _poseReady = false;
    _tfliteReady = false;
    debugPrint('MLManager: all ML resources released');
  }

  Map<String, bool> get status => {
        'tfliteReady': _tfliteReady,
        'poseReady': _poseReady,
      };
}
