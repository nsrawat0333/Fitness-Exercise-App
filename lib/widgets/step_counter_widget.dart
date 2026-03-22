import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../utils/app_utils.dart';

/// Circular step counter widget with animated progress ring.
class StepCounterWidget extends StatefulWidget {
  final int steps;
  final int goal;

  const StepCounterWidget({
    super.key,
    required this.steps,
    required this.goal,
  });

  @override
  State<StepCounterWidget> createState() => _StepCounterWidgetState();
}

class _StepCounterWidgetState extends State<StepCounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = widget.steps / widget.goal;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardLight.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  CircularPercentIndicator(
                    radius: 100,
                    lineWidth: 14,
                    percent: progress * _animation.value,
                    animation: false,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColors.stepRing,
                    backgroundColor: AppColors.stepTrack,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppUtils.formatNumber(
                            (widget.steps * _animation.value).round(),
                          ),
                          style: AppTextStyles.stepCount,
                        ),
                        Text('STEPS', style: AppTextStyles.stepLabel),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          'GOAL: ${AppUtils.formatNumber(widget.goal)} STEPS',
                          style: AppTextStyles.cardLabel.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
