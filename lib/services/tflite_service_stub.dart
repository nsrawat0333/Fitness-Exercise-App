import 'dart:io';
import 'package:flutter/foundation.dart';
import 'body_scan_types.dart';

class TFLiteService {
  static final TFLiteService _instance = TFLiteService._internal();
  factory TFLiteService() => _instance;
  TFLiteService._internal();

  Future<void> initialize() async {
    debugPrint("TFLite natively unavailable on this platform (Web). Using stub.");
  }

  Future<BodyScanResult> analyzeBodyImage(File imageFile) async {
    // Return a dummy error string indicating web isn't supported for this native ML feature
    return BodyScanResult(
      type: BodyType.unknown,
      description: "ERROR: Real-time ML Body Scanning requires native processing. Please run the app on an Android or iOS emulator/device rather than Chrome Web.",
      confidence: 0.0,
    );
  }
}
