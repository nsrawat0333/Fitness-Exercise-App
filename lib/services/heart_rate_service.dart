import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class HeartRateReading {
  final int bpm;
  final bool isMeasuring;
  final double signalQuality;

  HeartRateReading({
    required this.bpm,
    required this.isMeasuring,
    this.signalQuality = 0.0,
  });
}

class HeartRateService {
  static final HeartRateService _instance = HeartRateService._internal();
  factory HeartRateService() => _instance;
  HeartRateService._internal();

  CameraController? _cameraController;
  bool _isProcessingFrame = false;

  final ValueNotifier<HeartRateReading> readingNotifier =
      ValueNotifier(HeartRateReading(bpm: 0, isMeasuring: false));

  // PPG algorithm state
  final List<double> _redVariations = [];
  Timer? _bpmTimer;
  DateTime? _measurementStartTime;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.torch);
  }

  Future<void> startMeasurement() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      await initCamera();
    }
    
    _redVariations.clear();
    _measurementStartTime = DateTime.now();
    readingNotifier.value = HeartRateReading(bpm: 0, isMeasuring: true);

    await _cameraController!.setFlashMode(FlashMode.torch);
    _cameraController!.startImageStream((CameraImage image) {
      if (_isProcessingFrame) return;
      _isProcessingFrame = true;
      _processCameraImage(image);
      _isProcessingFrame = false;
    });

    // Provide interim BPM updates every 2 seconds
    _bpmTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _calculateBPM();
    });
  }

  void _processCameraImage(CameraImage image) {
    if (image.planes.isEmpty) return;

    // In YUV420, plane 0 is Y (luminance), which roughly correlates to red when flashlight is on a finger
    // For a real robust PPG, we would convert YUV to RGB and extract the Red channel.
    // For performance and simplicity, we average the Y plane.
    final yPlane = image.planes[0].bytes;
    int total = 0;
    
    // Process a centered sub-region to save time
    int width = image.width;
    int height = image.height;
    int scanSize = 50;
    
    int startX = (width - scanSize) ~/ 2;
    int startY = (height - scanSize) ~/ 2;
    
    int pixelCount = 0;

    for (int y = startY; y < startY + scanSize; y++) {
      for (int x = startX; x < startX + scanSize; x++) {
        int index = y * width + x;
        if (index < yPlane.length) {
          total += yPlane[index];
          pixelCount++;
        }
      }
    }

    if (pixelCount > 0) {
      double avgLoc = total / pixelCount;
      _redVariations.add(avgLoc);
      
      // Keep only last ~250 frames (approx 8 seconds at 30fps)
      if (_redVariations.length > 250) {
        _redVariations.removeAt(0);
      }
    }
  }

  void _calculateBPM() {
    if (_redVariations.length < 50) return; // Not enough data yet

    // Find peaks and valleys
    int peakCount = 0;
    double threshold = 0;
    
    // Calculate simple moving average as threshold
    double sum = _redVariations.fold(0, (p, c) => p + c);
    double avg = sum / _redVariations.length;
    threshold = avg;

    bool wasAbove = false;
    List<int> peakIndices = [];

    for (int i = 0; i < _redVariations.length; i++) {
      bool isAbove = _redVariations[i] > threshold;
      if (isAbove && !wasAbove) {
        // Crossed threshold upwards = roughly a beat
        peakIndices.add(i);
        peakCount++;
      }
      wasAbove = isAbove;
    }

    if (peakIndices.length >= 2) {
      // Calculate intervals
      double avgIntervalFrames = (peakIndices.last - peakIndices.first) / (peakIndices.length - 1);
      
      // Assuming 30 FPS for low resolution stream
      double fps = 30.0; 
      
      // Seconds elapsed
      int secondsElapsed = DateTime.now().difference(_measurementStartTime!).inSeconds;
      
      // Better fallback: if we have time tracking, calculate actual FPS
      if (_redVariations.length > 30 && secondsElapsed > 0) {
        fps = _redVariations.length / (DateTime.now().difference(_measurementStartTime!).inMilliseconds / 1000.0);
      }
      
      if (avgIntervalFrames > 0) {
        int bpm = ((fps * 60) / avgIntervalFrames).round();
        
        // Clamp to realistic values
        bpm = bpm.clamp(40, 200);
        
        // Calculate a faux "quality" based on variance amplitude
        double variance = 0.0;
        for (double v in _redVariations) {
          variance += (v - avg) * (v - avg);
        }
        variance = variance / _redVariations.length;
        double quality = (variance / 100).clamp(0.0, 1.0); // Rough heuristic
        
        readingNotifier.value = HeartRateReading(
          bpm: bpm, 
          isMeasuring: true,
          signalQuality: quality,
        );
      }
    }
  }

  Future<void> stopMeasurement() async {
    _bpmTimer?.cancel();
    if (_cameraController != null && _cameraController!.value.isStreamingImages) {
      await _cameraController!.stopImageStream();
    }
    await _cameraController?.setFlashMode(FlashMode.off);
    
    // Keep the final reading
    readingNotifier.value = HeartRateReading(
      bpm: readingNotifier.value.bpm,
      isMeasuring: false,
    );
  }

  void dispose() {
    _bpmTimer?.cancel();
    _cameraController?.dispose();
    readingNotifier.dispose();
  }
}
