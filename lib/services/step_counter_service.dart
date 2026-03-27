import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepData {
  final int steps;
  final double distanceKm;
  final int calories;

  StepData(this.steps, this.distanceKm, this.calories);
}

class StepCounterService {
  static final StepCounterService _instance = StepCounterService._internal();
  factory StepCounterService() => _instance;

  StepCounterService._internal();

  // Peak detection constants
  static const double _stepThreshold = 12.0; 
  static const int _delayMs = 300; 
  
  // Estimation constants
  static const double _strideLengthM = 0.76; // Average stride length
  static const double _weightKg = 70.0; // Default weight

  StreamSubscription<UserAccelerometerEvent>? _accelSubscription;
  int _steps = 0;
  DateTime _lastStepTime = DateTime.now();
  
  final ValueNotifier<StepData> stepDataNotifier = ValueNotifier(StepData(0, 0, 0));

  Future<void> init() async {
    await _loadSteps();
    _startListening();
  }

  void _startListening() {
    _accelSubscription = userAccelerometerEventStream(samplingPeriod: SensorInterval.gameInterval).listen((event) {
      double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      
      if (magnitude > _stepThreshold) {
        DateTime now = DateTime.now();
        if (now.difference(_lastStepTime).inMilliseconds > _delayMs) {
          _lastStepTime = now;
          _incrementStep();
        }
      }
    });
  }

  void _incrementStep() {
    _steps++;
    _updateNotifier();
    _saveSteps(); // Persist every step (in a real app, might want to batch this)
  }

  void _updateNotifier() {
    double distanceKm = (_steps * _strideLengthM) / 1000;
    // VERY rough estimate: distance * weight * 1.036
    int calories = (distanceKm * _weightKg * 1.036).round();
    stepDataNotifier.value = StepData(_steps, distanceKm, calories);
  }

  Future<void> _loadSteps() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if it's a new day to reset steps
    String today = _getTodayKey();
    String? lastSavedDay = prefs.getString('last_saved_day');
    
    if (lastSavedDay != today) {
      // New day, reset steps
      _steps = 0;
      await prefs.setString('last_saved_day', today);
      await prefs.setInt('steps_$today', 0);
    } else {
      // Load today's steps
      _steps = prefs.getInt('steps_$today') ?? 0;
    }
    
    // Ensure weekly bars start at 0 if not present
    if (!prefs.containsKey('weekly_bars_0')) {
      for (int i=0; i<7; i++) {
        prefs.setDouble('weekly_bars_$i', 0.0);
      }
    }
    
    _updateNotifier();
  }

  Future<void> _saveSteps() async {
    final prefs = await SharedPreferences.getInstance();
    String today = _getTodayKey();
    await prefs.setInt('steps_$today', _steps);
  }

  String _getTodayKey() {
    DateTime now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  void dispose() {
    _accelSubscription?.cancel();
    stepDataNotifier.dispose();
  }
}
