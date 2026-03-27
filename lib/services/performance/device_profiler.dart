import 'dart:io';
import 'package:flutter/foundation.dart';

/// Detects device capability (low-end vs high-end) and exposes
/// performance tiers so other managers can adjust behaviour dynamically.
enum DeviceTier { low, medium, high }

class DeviceProfiler {
  static final DeviceProfiler _instance = DeviceProfiler._internal();
  factory DeviceProfiler() => _instance;
  DeviceProfiler._internal();

  DeviceTier _tier = DeviceTier.medium;
  int _totalRamMB = 0;
  int _cpuCores = 0;
  bool _initialized = false;

  DeviceTier get tier => _tier;
  int get totalRamMB => _totalRamMB;
  int get cpuCores => _cpuCores;
  bool get isLowEnd => _tier == DeviceTier.low;
  bool get isHighEnd => _tier == DeviceTier.high;

  /// Call once at app startup to profile the device.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    _cpuCores = Platform.numberOfProcessors;

    // Estimate RAM from available processors as a heuristic.
    // On Android, ProcessInfo gives a rough idea.
    try {
      final info = ProcessInfo.currentRss; // bytes
      _totalRamMB = (info / (1024 * 1024)).round();
    } catch (_) {
      _totalRamMB = 0; // fallback
    }

    // Classification heuristic
    if (_cpuCores <= 4) {
      _tier = DeviceTier.low;
    } else if (_cpuCores <= 6) {
      _tier = DeviceTier.medium;
    } else {
      _tier = DeviceTier.high;
    }

    debugPrint('DeviceProfiler: cores=$_cpuCores  tier=$_tier');
  }

  /// Quick summary map for debug overlays.
  Map<String, dynamic> get summary => {
        'tier': _tier.name,
        'cpuCores': _cpuCores,
        'ramMB': _totalRamMB,
      };
}
