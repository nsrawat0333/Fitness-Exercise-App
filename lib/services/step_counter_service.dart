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

class StepHistoryEntry {
  final DateTime date;
  final int steps;
  final bool goalReached;

  const StepHistoryEntry({
    required this.date,
    required this.steps,
    required this.goalReached,
  });
}

class StepStats {
  final List<int> weeklySteps;
  final List<String> weeklyLabels;
  final int weeklyAverage;
  final int monthlyAverage;
  final int monthlyCurrent;
  final int monthlyTarget;
  final double weeklyTrendPercent;
  final List<StepHistoryEntry> history;

  const StepStats({
    required this.weeklySteps,
    required this.weeklyLabels,
    required this.weeklyAverage,
    required this.monthlyAverage,
    required this.monthlyCurrent,
    required this.monthlyTarget,
    required this.weeklyTrendPercent,
    required this.history,
  });

  factory StepStats.empty({required int monthlyTarget}) {
    return StepStats(
      weeklySteps: const [0, 0, 0, 0, 0, 0, 0],
      weeklyLabels: const ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
      weeklyAverage: 0,
      monthlyAverage: 0,
      monthlyCurrent: 0,
      monthlyTarget: monthlyTarget,
      weeklyTrendPercent: 0,
      history: const [],
    );
  }
}

class StepCounterService {
  static final StepCounterService _instance = StepCounterService._internal();
  factory StepCounterService() => _instance;

  StepCounterService._internal();

  static const int dailyGoal = 10000;

  // Peak detection constants
  static const double _stepThreshold = 12.0; 
  static const int _delayMs = 300; 
  
  // Estimation constants
  static const double _strideLengthM = 0.76; // Average stride length
  static const double _weightKg = 70.0; // Default weight

  StreamSubscription<UserAccelerometerEvent>? _accelSubscription;
  int _steps = 0;
  DateTime _lastStepTime = DateTime.now();
  final Map<String, int> _dailyStepCache = {};
  
  final ValueNotifier<StepData> stepDataNotifier = ValueNotifier(StepData(0, 0, 0));
  final ValueNotifier<StepStats> stepStatsNotifier =
      ValueNotifier(StepStats.empty(monthlyTarget: dailyGoal * 30));

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
    _dailyStepCache[_getTodayKey()] = _steps;
    _updateNotifier();
    _saveSteps(); // Persist every step (in a real app, might want to batch this)
  }

  void _updateNotifier() {
    double distanceKm = (_steps * _strideLengthM) / 1000;
    // VERY rough estimate: distance * weight * 1.036
    int calories = (distanceKm * _weightKg * 1.036).round();
    stepDataNotifier.value = StepData(_steps, distanceKm, calories);
    stepStatsNotifier.value = _buildStepStats();
  }

  Future<void> _loadSteps() async {
    final prefs = await SharedPreferences.getInstance();
    await _primeDailyStepCache(prefs);
    
    // Check if it's a new day to reset steps
    String today = _getTodayKey();
    String? lastSavedDay = prefs.getString('last_saved_day');
    
    if (lastSavedDay != today) {
      // New day, reset steps
      _steps = 0;
      await prefs.setString('last_saved_day', today);
      await prefs.setInt('steps_$today', 0);
      _dailyStepCache[today] = 0;
    } else {
      // Load today's steps
      _steps = _dailyStepCache[today] ?? 0;
    }

    _updateNotifier();
  }

  Future<void> _saveSteps() async {
    final prefs = await SharedPreferences.getInstance();
    String today = _getTodayKey();
    await prefs.setInt('steps_$today', _steps);
  }

  Future<void> _primeDailyStepCache(SharedPreferences prefs) async {
    _dailyStepCache.clear();
    final now = DateTime.now();
    for (int i = 0; i < 45; i++) {
      final date = now.subtract(Duration(days: i));
      final key = _dateKey(date);
      _dailyStepCache[key] = prefs.getInt('steps_$key') ?? 0;
    }
  }

  StepStats _buildStepStats() {
    final now = DateTime.now();
    final weeklySteps = List<int>.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return _stepsForDate(date);
    });

    final weeklyLabels = List<String>.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return _weekdayLabel(date.weekday);
    });

    final currentWeekAvg = (weeklySteps.reduce((a, b) => a + b) / weeklySteps.length).round();
    final previousWeekSteps = List<int>.generate(7, (index) {
      final date = now.subtract(Duration(days: 13 - index));
      return _stepsForDate(date);
    });
    final previousWeekAvg = (previousWeekSteps.reduce((a, b) => a + b) / previousWeekSteps.length).round();

    double trendPercent;
    if (previousWeekAvg == 0) {
      trendPercent = currentWeekAvg == 0 ? 0 : 100;
    } else {
      trendPercent = ((currentWeekAvg - previousWeekAvg) / previousWeekAvg) * 100;
    }

    int monthlyCurrent = 0;
    for (int day = 1; day <= now.day; day++) {
      monthlyCurrent += _stepsForDate(DateTime(now.year, now.month, day));
    }

    final monthDays = DateTime(now.year, now.month + 1, 0).day;
    final monthlyAverage = now.day == 0 ? 0 : (monthlyCurrent / now.day).round();

    final history = <StepHistoryEntry>[];
    for (int i = 0; i < 14; i++) {
      final date = now.subtract(Duration(days: i));
      final steps = _stepsForDate(date);
      if (i == 0 || steps > 0) {
        history.add(
          StepHistoryEntry(
            date: date,
            steps: steps,
            goalReached: steps >= dailyGoal,
          ),
        );
      }
      if (history.length == 5) break;
    }

    return StepStats(
      weeklySteps: weeklySteps,
      weeklyLabels: weeklyLabels,
      weeklyAverage: currentWeekAvg,
      monthlyAverage: monthlyAverage,
      monthlyCurrent: monthlyCurrent,
      monthlyTarget: monthDays * dailyGoal,
      weeklyTrendPercent: trendPercent,
      history: history,
    );
  }

  int _stepsForDate(DateTime date) {
    return _dailyStepCache[_dateKey(date)] ?? 0;
  }

  String _weekdayLabel(int weekday) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final safe = weekday.clamp(1, 7);
    return labels[safe - 1];
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String _getTodayKey() {
    DateTime now = DateTime.now();
    return _dateKey(now);
  }

  void dispose() {
    _accelSubscription?.cancel();
    stepDataNotifier.dispose();
    stepStatsNotifier.dispose();
  }
}
