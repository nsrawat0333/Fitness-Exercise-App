import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tflite_service.dart';

// Re-export BodyType and BodyScanResult so the rest of the app doesn't break
export 'tflite_service.dart' show BodyType, BodyScanResult;



class BodyScanService {
  final TFLiteService _tflite = TFLiteService();

  Future<BodyScanResult> analyzeBodyImage(File imageFile) async {
    try {
      // 1. Immediately run TFLite inference directly on-device
      final result = await _tflite.analyzeBodyImage(imageFile);

      // 2. Save classification to Firebase Profile (async, no need to await)
      _saveBodyTypeToProfile(result.type);

      return result;
    } catch (e) {
      throw Exception('Failed to analyze body image using local ML: $e');
    }
  }



  Future<void> _saveBodyTypeToProfile(BodyType type) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'bodyType': type.name,
        'bodyScanDate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
}
