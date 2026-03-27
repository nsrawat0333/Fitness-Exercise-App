import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectionService {
  static final PoseDetectionService _instance = PoseDetectionService._internal();
  factory PoseDetectionService() => _instance;
  PoseDetectionService._internal();

  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(
      model: PoseDetectionModel.base,
      mode: PoseDetectionMode.stream,
    ),
  );

  bool _isProcessingFrame = false;

  void dispose() {
    _poseDetector.close();
  }

  Future<List<Pose>> processCameraFrame(CameraImage image, int sensorOrientation) async {
    if (_isProcessingFrame) return [];
    _isProcessingFrame = true;

    try {
      final inputImage = _inputImageFromCameraImage(image, sensorOrientation);
      if (inputImage == null) return [];

      final poses = await _poseDetector.processImage(inputImage);
      return poses;
    } catch (e) {
      debugPrint('PoseDetectionService error: $e');
      return [];
    } finally {
      _isProcessingFrame = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image, int sensorOrientation) {
    if (image.planes.isEmpty) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    // Provide default bytes if only one plane exists (e.g., bgra8888)
    final bytes = image.planes.length == 1
        ? image.planes.first.bytes
        : _yuv420ToBytes(image);
        
    if (bytes == null) return null;

    final size = Size(image.width.toDouble(), image.height.toDouble());
    
    final rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) return null;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImageMetadata(
          bytesPerRow: plane.bytesPerRow,
          size: size,
          rotation: rotation,
          format: format,
        );
      },
    ).toList();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: size,
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Uint8List? _yuv420ToBytes(CameraImage image) {
    if (Platform.isAndroid && image.format.group == ImageFormatGroup.yuv420) {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      return allBytes.done().buffer.asUint8List();
    }
    
    // For iOS format mainly BGRA8888 
    if (Platform.isIOS && image.format.group == ImageFormatGroup.bgra8888) {
        return image.planes[0].bytes;
    }

    return null;
  }
}
