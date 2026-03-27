import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'device_profiler.dart';

/// Controls Lottie animation rendering based on device capability.
/// On low-end devices, animations are replaced with static placeholders.
class AnimationManager {
  static final AnimationManager _instance = AnimationManager._internal();
  factory AnimationManager() => _instance;
  AnimationManager._internal();

  bool _animationsEnabled = true;
  double _animationSpeed = 1.0;

  bool get animationsEnabled => _animationsEnabled;
  double get animationSpeed => _animationSpeed;

  void init() {
    final tier = DeviceProfiler().tier;

    switch (tier) {
      case DeviceTier.low:
        _animationsEnabled = false; // Disable Lottie completely
        _animationSpeed = 1.0;
        break;
      case DeviceTier.medium:
        _animationsEnabled = true;
        _animationSpeed = 1.5; // Play faster to reduce GPU frames
        break;
      case DeviceTier.high:
        _animationsEnabled = true;
        _animationSpeed = 1.0; // Full quality
        break;
    }

    debugPrint('AnimationManager: enabled=$_animationsEnabled  speed=$_animationSpeed');
  }

  /// Returns a Lottie widget or a static placeholder icon based on device tier.
  /// Use this everywhere instead of directly calling `Lottie.asset()`.
  Widget buildLottie({
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    IconData fallbackIcon = Icons.fitness_center,
    Color fallbackColor = const Color(0xFF5B7E5F),
  }) {
    if (!_animationsEnabled) {
      // Static placeholder for low-end devices
      return SizedBox(
        width: width ?? 200,
        height: height ?? 200,
        child: Center(
          child: Icon(fallbackIcon, size: 64, color: fallbackColor.withValues(alpha: 0.5)),
        ),
      );
    }

    return Lottie.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      frameRate: DeviceProfiler().isHighEnd ? FrameRate.max : FrameRate(30),
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Lottie error for $assetPath: $error');
        return SizedBox(
          width: width ?? 200,
          height: height ?? 200,
          child: Center(
            child: Icon(fallbackIcon, size: 64, color: fallbackColor.withValues(alpha: 0.5)),
          ),
        );
      },
    );
  }
}
