enum BodyType { lean, fit, fat, unknown }

class BodyScanResult {
  final BodyType type;
  final String description;
  final double confidence;

  BodyScanResult({
    required this.type,
    required this.description,
    required this.confidence,
  });
}
