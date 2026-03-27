import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';
import 'device_profiler.dart';

/// Manages image cache sizes and provides manual eviction triggers
/// to prevent OOM crashes and excessive GC pauses.
class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  bool _initialized = false;

  /// Configure the Flutter image cache based on device tier.
  void init() {
    if (_initialized) return;
    _initialized = true;

    final tier = DeviceProfiler().tier;

    switch (tier) {
      case DeviceTier.low:
        // Tiny cache: 20 images, 30 MB
        PaintingBinding.instance.imageCache.maximumSize = 20;
        PaintingBinding.instance.imageCache.maximumSizeBytes = 30 * 1024 * 1024;
        break;
      case DeviceTier.medium:
        // Medium cache: 50 images, 60 MB
        PaintingBinding.instance.imageCache.maximumSize = 50;
        PaintingBinding.instance.imageCache.maximumSizeBytes = 60 * 1024 * 1024;
        break;
      case DeviceTier.high:
        // Large cache: 100 images, 120 MB
        PaintingBinding.instance.imageCache.maximumSize = 100;
        PaintingBinding.instance.imageCache.maximumSizeBytes = 120 * 1024 * 1024;
        break;
    }

    debugPrint('MemoryManager: imageCache set for ${tier.name} tier');
  }

  /// Manually evict all cached images (call before heavy screens).
  void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    debugPrint('MemoryManager: image cache cleared');
  }

  /// Get current cache stats for debugging.
  Map<String, int> get cacheStats => {
        'currentSize': PaintingBinding.instance.imageCache.currentSize,
        'currentSizeBytes': PaintingBinding.instance.imageCache.currentSizeBytes,
      };
}
