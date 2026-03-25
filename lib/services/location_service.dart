import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Manages location permissions, current position, and live position stream.
class LocationService {
  StreamSubscription<Position>? _positionSub;

  /// Check and request location permissions. Returns true if granted.
  static Future<bool> ensurePermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services disabled');
      return false;
    }

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        debugPrint('Location permission denied');
        return false;
      }
    }
    if (perm == LocationPermission.deniedForever) {
      debugPrint('Location permission permanently denied');
      return false;
    }
    return true;
  }

  /// Get the current device position.
  static Future<Position?> getCurrentPosition() async {
    try {
      final ok = await ensurePermissions();
      if (!ok) return null;
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint("Error fetching current position: $e");
      return null;
    }
  }

  /// Start listening to position changes.
  void startTracking({
    required void Function(Position position) onPosition,
    int distanceFilter = 5,
  }) {
    _positionSub?.cancel();
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );
    _positionSub = Geolocator.getPositionStream(locationSettings: settings).listen(
      onPosition,
      onError: (e) => debugPrint('Location stream error: $e'),
    );
  }

  /// Calculate distance between two positions in meters.
  static double distanceBetween(Position a, Position b) {
    return Geolocator.distanceBetween(a.latitude, a.longitude, b.latitude, b.longitude);
  }

  /// Stop listening to position changes.
  void stopTracking() {
    _positionSub?.cancel();
    _positionSub = null;
  }

  void dispose() {
    stopTracking();
  }
}
