import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../utils/app_utils.dart';

/// AI Detection active card showing exercise counts.
class AiDetectionCard extends StatefulWidget {
  final int pushUps;
  final int pullUps;
  final int chinUps;

  const AiDetectionCard({
    super.key,
    required this.pushUps,
    required this.pullUps,
    required this.chinUps,
  });

  @override
  State<AiDetectionCard> createState() => _AiDetectionCardState();
}

class _AiDetectionCardState extends State<AiDetectionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    Future.delayed(const Duration(milliseconds: 600), () {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.aiCardBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.aiActiveDot,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AI DETECTION ACTIVE',
                        style: AppTextStyles.cardLabelLight.copyWith(
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ── Stats Row ──
                  Row(
                    children: [
                      _StatColumn(
                        value: AppUtils.padTwo(widget.pushUps),
                        label: 'PUSH-UPS',
                      ),
                      const SizedBox(width: 24),
                      _StatColumn(
                        value: AppUtils.padTwo(widget.pullUps),
                        label: 'PULL-UPS',
                      ),
                      const SizedBox(width: 24),
                      _StatColumn(
                        value: AppUtils.padTwo(widget.chinUps),
                        label: 'CHIN-UPS',
                      ),
                      const Spacer(),
                      // Action button
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _StatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.cardValueLight.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.cardLabelLight.copyWith(fontSize: 10)),
      ],
    );
  }
}
