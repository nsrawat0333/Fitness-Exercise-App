import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A reusable animated breathing circle widget for workout relaxation phases.
/// Shows an expanding/contracting circle with "Breathe In" / "Breathe Out" text.
class BreathingAnimationWidget extends StatefulWidget {
  /// Primary color for the breathing circle.
  final Color color;

  /// Secondary/glow color.
  final Color glowColor;

  /// Size of the widget.
  final double size;

  /// Label text shown below (e.g. "Relax & Breathe" or "Recovery").
  final String label;

  const BreathingAnimationWidget({
    super.key,
    this.color = const Color(0xFF5B7E5F),
    this.glowColor = const Color(0xFF52B788),
    this.size = 200,
    this.label = 'Relax & Breathe',
  });

  @override
  State<BreathingAnimationWidget> createState() => _BreathingAnimationWidgetState();
}

class _BreathingAnimationWidgetState extends State<BreathingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // 4s per breath cycle
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final isInhaling = _controller.status == AnimationStatus.forward;
        final scale = _scaleAnimation.value;
        final glowOpacity = _opacityAnimation.value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Breathing circle
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow ring 3
                  Transform.scale(
                    scale: scale * 1.3,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.glowColor.withValues(alpha: glowOpacity * 0.15),
                      ),
                    ),
                  ),
                  // Outer glow ring 2
                  Transform.scale(
                    scale: scale * 1.15,
                    child: Container(
                      width: widget.size * 0.85,
                      height: widget.size * 0.85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.glowColor.withValues(alpha: glowOpacity * 0.25),
                      ),
                    ),
                  ),
                  // Main circle
                  Transform.scale(
                    scale: scale,
                    child: Container(
                      width: widget.size * 0.7,
                      height: widget.size * 0.7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.color.withValues(alpha: 0.9),
                            widget.color.withValues(alpha: 0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.glowColor.withValues(alpha: glowOpacity * 0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isInhaling
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: widget.size * 0.2,
                        ),
                      ),
                    ),
                  ),
                  // Rotating particle dots
                  ...List.generate(6, (i) {
                    final angle = (i / 6) * 2 * math.pi + (_controller.value * math.pi);
                    final radius = widget.size * 0.35 * scale;
                    return Positioned(
                      left: widget.size / 2 + radius * math.cos(angle) - 3,
                      top: widget.size / 2 + radius * math.sin(angle) - 3,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: glowOpacity),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Breathe In / Breathe Out text
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                isInhaling ? 'Breathe In' : 'Breathe Out',
                key: ValueKey(isInhaling),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: widget.color,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Label
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                color: widget.color.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}
