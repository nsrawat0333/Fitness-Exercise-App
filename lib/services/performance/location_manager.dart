import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../location_service.dart';
import 'device_profiler.dart';

/// Wraps LocationService with interval-based throttling to prevent excessive
/// GPS polling that drains battery and causes UI jank.
class LocationManager {
  static final LocationManager _instance = LocationManager._internal();
  factory LocationManager() => _instance;
  LocationManager._internal();

  final LocationService _locationService = LocationService();
  Position? _lastPosition;
  DateTime? _lastUpdate;
  bool _isTracking = false;

  Position? get lastPosition => _lastPosition;
  bool get isTracking => _isTracking;

  /// Minimum interval between position updates (in milliseconds).
  int get _updateIntervalMs {
    switch (DeviceProfiler().tier) {
      case DeviceTier.low:
        return 5000; // 5 seconds on low-end
      case DeviceTier.medium:
        return 3000; // 3 seconds on medium
      case DeviceTier.high:
        return 2000; // 2 seconds on high-end
    }
  }

  /// Minimum distance filter (meters) before an update fires.
  int get _distanceFilter {
    switch (DeviceProfiler().tier) {
      case DeviceTier.low:
        return 10;
      case DeviceTier.medium:
        return 7;
      case DeviceTier.high:
        return 5;
    }
  }

  /// Start tracking with interval-based throttling.
  void startTracking({required void Function(Position position) onPosition}) {
    _isTracking = true;

    _locationService.startTracking(
      distanceFilter: _distanceFilter,
      onPosition: (pos) {
        final now = DateTime.now();
        // Throttle: drop updates that arrive too fast
        if (_lastUpdate != null &&
            now.difference(_lastUpdate!).inMilliseconds < _updateIntervalMs) {
          return;
        }
        _lastPosition = pos;
        _lastUpdate = now;
        onPosition(pos);
      },
    );

    debugPrint(
        'LocationManager: tracking started (interval=${_updateIntervalMs}ms, distance=${_distanceFilter}m)');
  }

  /// Stop tracking.
  void stopTracking() {
    _locationService.stopTracking();
    _isTracking = false;
    debugPrint('LocationManager: tracking stopped');
  }

  void dispose() {
    stopTracking();
    _locationService.dispose();
  }
}
