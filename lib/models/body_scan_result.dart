/// Data class representing the result of a body scan (AI or BMI-based).
class BodyScanResult {
  final String bodyType; // 'skinny', 'normal', 'overweight', 'fat'
  final String recommendation; // 'diet-heavy', 'workout-heavy', 'balanced'
  final double confidence; // 0.0 to 1.0 (1.0 for BMI-based)
  final DateTime timestamp;

  const BodyScanResult({
    required this.bodyType,
    required this.recommendation,
    this.confidence = 1.0,
    required this.timestamp,
  });

  /// Create a BodyScanResult from BMI calculation (fallback when no ML model).
  factory BodyScanResult.fromBMI(double bmi) {
    String type;
    String rec;

    if (bmi < 18.5) {
      type = 'skinny';
      rec = 'diet-heavy';
    } else if (bmi < 25) {
      type = 'normal';
      rec = 'balanced';
    } else if (bmi < 30) {
      type = 'overweight';
      rec = 'workout-heavy';
    } else {
      type = 'fat';
      rec = 'workout-heavy';
    }

    return BodyScanResult(
      bodyType: type,
      recommendation: rec,
      confidence: 1.0, // BMI-based is deterministic
      timestamp: DateTime.now(),
    );
  }

  /// Convert to JSON-compatible map.
  Map<String, dynamic> toJson() => {
    'body_type': bodyType,
    'recommendation': recommendation,
    'confidence': confidence,
    'timestamp': timestamp.toIso8601String(),
  };

  @override
  String toString() => 'BodyScanResult(type: $bodyType, rec: $recommendation)';
}
