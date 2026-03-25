import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class RunLocationService {
  StreamSubscription<Position>? _positionStream;
  Function(Position)? onLocationUpdate;

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  /// Requests permissions and initializes the geolocator stream
  Future<bool> requestPermissions() async {
    // Check and request location permissions using permission_handler
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }
    
    if (status.isGranted) {
      // For background tracking on Android/iOS, request Always access
      var alwaysStatus = await Permission.locationAlways.status;
      if (!alwaysStatus.isGranted) {
        await Permission.locationAlways.request();
      }
      return true;
    }
    return false;
  }

  /// Starts streaming high accuracy location updates
  Future<void> startTracking(Function(Position) onUpdate) async {
    final hasPermission = await requestPermissions();
    if (!hasPermission) return;

    _isTracking = true;
    onLocationUpdate = onUpdate;

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 2, // Update every 2 meters
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      // Filter out inaccurate GPS hits (e.g. accuracy > 20 meters is usually a spike)
      if (position.accuracy <= 20) {
        onLocationUpdate?.call(position);
      }
    });
  }

  /// Pauses the stream
  void pauseTracking() {
    _positionStream?.pause();
    _isTracking = false;
  }

  /// Resumes the stream
  void resumeTracking() {
    _positionStream?.resume();
    _isTracking = true;
  }

  /// Stops tracking entirely and cleans up
  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    _isTracking = false;
  }
}
