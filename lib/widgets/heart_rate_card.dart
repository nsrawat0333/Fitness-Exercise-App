import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Heart rate card with ECG line animation.
class HeartRateCard extends StatefulWidget {
  final int bpm;

  const HeartRateCard({super.key, required this.bpm});

  @override
  State<HeartRateCard> createState() => _HeartRateCardState();
}

class _HeartRateCardState extends State<HeartRateCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.heartCardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Row: Heart icon + Live badge ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.heartPink.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: AppColors.heartPink,
                  size: 22,
                ),
              ),
              Row(
                children: [
                  _PulsingDot(),
                  const SizedBox(width: 4),
                  Text(
                    'Live',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.liveDot,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // ── Bottom: BPM + ECG ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${widget.bpm}',
                style: AppTextStyles.cardValueLarge.copyWith(fontSize: 28),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _EcgPainter(_controller.value),
                        size: Size.infinite,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text('AVG BPM', style: AppTextStyles.cardLabel),
        ],
      ),
    );
  }
}

/// Pulsing live dot indicator.
class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
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
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.liveDot.withValues(
              alpha: 0.5 + (_controller.value * 0.5),
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

/// Simple ECG line painter.
class _EcgPainter extends CustomPainter {
  final double progress;
  _EcgPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.heartPink.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final midY = size.height * 0.6;
    final width = size.width;

    path.moveTo(0, midY);

    // Create ECG-like waveform
    for (double x = 0; x <= width; x += 1) {
      final normalizedX = (x / width + progress) % 1.0;
      double y = midY;

      // Create heartbeat spike pattern
      final beatPos = (normalizedX * 3) % 1.0;
      if (beatPos > 0.4 && beatPos < 0.45) {
        y = midY - size.height * 0.15;
      } else if (beatPos > 0.45 && beatPos < 0.48) {
        y = midY + size.height * 0.5;
      } else if (beatPos > 0.48 && beatPos < 0.52) {
        y = midY - size.height * 0.6;
      } else if (beatPos > 0.52 && beatPos < 0.55) {
        y = midY + size.height * 0.2;
      } else {
        // Small noise
        y = midY + sin(normalizedX * 20) * 1;
      }

      path.lineTo(x, y.clamp(0, size.height));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EcgPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
