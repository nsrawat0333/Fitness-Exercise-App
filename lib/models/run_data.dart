
/// Types of running activities.
enum RunType {
  roadRun('Road Run', '🏙️', 'Flat terrain, consistent pace. Focus on maintaining cadence.'),
  mountainRun('Mountain Run', '⛰️', 'Steep inclines ahead! Shorten stride, build stamina.'),
  parkRun('Park Run', '🌳', 'Natural trails — stay aware of uneven surfaces.'),
  custom('Custom', '🎯', 'Your run, your rules. Push your limits!');

  final String label;
  final String emoji;
  final String tip;
  const RunType(this.label, this.emoji, this.tip);
}

/// A single recorded run session.
class RunRecord {
  final String id;
  final RunType type;
  final double distanceMeters;
  final int durationSeconds;
  final int steps;
  final double calories;
  final DateTime startTime;
  final DateTime endTime;
  final List<LatLngPoint> route;

  // Goals
  final double? targetDistanceMeters;
  final int? targetDurationSeconds;
  final double? targetCalories;
  final int? targetSteps;

  RunRecord({
    required this.id,
    required this.type,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.steps,
    required this.calories,
    required this.startTime,
    required this.endTime,
    this.route = const [],
    this.targetDistanceMeters,
    this.targetDurationSeconds,
    this.targetCalories,
    this.targetSteps,
  });

  double get distanceKm => distanceMeters / 1000.0;

  String get formattedDuration {
    final h = durationSeconds ~/ 3600;
    final m = (durationSeconds % 3600) ~/ 60;
    final s = durationSeconds % 60;
    if (h > 0) return '${h}h ${m}m ${s}s';
    return '${m}m ${s}s';
  }

  String get formattedPace {
    if (distanceKm == 0) return '--:--';
    final paceSeconds = (durationSeconds / distanceKm).floor();
    final pm = paceSeconds ~/ 60;
    final ps = paceSeconds % 60;
    return '$pm:${ps.toString().padLeft(2, '0')} /km';
  }

  double get avgSpeedKmh {
    if (durationSeconds == 0) return 0;
    return distanceKm / (durationSeconds / 3600.0);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'distanceMeters': distanceMeters,
    'durationSeconds': durationSeconds,
    'steps': steps,
    'calories': calories,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'route': route.map((p) => p.toJson()).toList(),
    'targetDistanceMeters': targetDistanceMeters,
    'targetDurationSeconds': targetDurationSeconds,
    'targetCalories': targetCalories,
    'targetSteps': targetSteps,
  };

  factory RunRecord.fromJson(Map<String, dynamic> json) => RunRecord(
    id: json['id'],
    type: RunType.values.firstWhere((t) => t.name == json['type'], orElse: () => RunType.custom),
    distanceMeters: (json['distanceMeters'] as num).toDouble(),
    durationSeconds: json['durationSeconds'],
    steps: json['steps'] ?? 0,
    calories: (json['calories'] as num?)?.toDouble() ?? 0,
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
    route: (json['route'] as List?)?.map((p) => LatLngPoint.fromJson(p)).toList() ?? [],
    targetDistanceMeters: (json['targetDistanceMeters'] as num?)?.toDouble(),
    targetDurationSeconds: json['targetDurationSeconds'],
    targetCalories: (json['targetCalories'] as num?)?.toDouble(),
    targetSteps: json['targetSteps'],
  );
}

/// Lightweight lat/lng wrapper for route persistence.
class LatLngPoint {
  final double lat;
  final double lng;
  const LatLngPoint(this.lat, this.lng);

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};

  factory LatLngPoint.fromJson(Map<String, dynamic> json) =>
      LatLngPoint((json['lat'] as num).toDouble(), (json['lng'] as num).toDouble());
}
