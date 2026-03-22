import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Water tracker card with animated fill effect.
class WaterTrackerCard extends StatefulWidget {
  final int glasses;
  final int goal;

  const WaterTrackerCard({
    super.key,
    required this.glasses,
    required this.goal,
  });

  @override
  State<WaterTrackerCard> createState() => _WaterTrackerCardState();
}

class _WaterTrackerCardState extends State<WaterTrackerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fillAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = ((widget.glasses / widget.goal) * 100).round();

    return AnimatedBuilder(
      animation: _fillAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.waterCardBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Row: Icon + Percentage ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Water drop icon with fill animation
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.waterDropBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.water_drop,
                          color: AppColors.waterDrop.withValues(alpha: 0.3),
                          size: 24,
                        ),
                        ClipRect(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            heightFactor: _fillAnimation.value * widget.glasses / widget.goal,
                            child: Icon(
                              Icons.water_drop,
                              color: AppColors.waterDrop,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${(percent * _fillAnimation.value).round()}%',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // ── Bottom: Count ──
              Text(
                '${widget.glasses}/${widget.goal}',
                style: AppTextStyles.cardValueLarge.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 2),
              Text('GLASSES', style: AppTextStyles.cardLabel),
            ],
          ),
        );
      },
    );
  }
}
