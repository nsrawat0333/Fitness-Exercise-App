import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../yoga_home_screen.dart';

/// Yoga Onboarding – Plan Generation / Completion Screen
/// Shows animated progress while "generating" the user's yoga plan.
class YogaPlanGenerationScreen extends StatefulWidget {
  final double heightCm;
  final double weightKg;
  final bool heightIsCm;
  final bool weightIsKg;

  const YogaPlanGenerationScreen({
    super.key,
    this.heightCm = 165,
    this.weightKg = 60,
    this.heightIsCm = true,
    this.weightIsKg = true,
  });

  @override
  State<YogaPlanGenerationScreen> createState() => _YogaPlanGenerationScreenState();
}

class _YogaPlanGenerationScreenState extends State<YogaPlanGenerationScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  bool _step1Done = false;
  bool _step2Done = false;
  bool _step3Done = false;
  bool _step4Done = false;
  bool _allDone = false;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressController.addListener(() {
      final val = _progressAnimation.value;
      setState(() {
        if (val >= 0.20 && !_step1Done) _step1Done = true;
        if (val >= 0.45 && !_step2Done) _step2Done = true;
        if (val >= 0.70 && !_step3Done) _step3Done = true;
        if (val >= 0.95 && !_step4Done) _step4Done = true;
      });
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _allDone = true);
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const YogaHomeScreen()),
              (route) => route.isFirst,
            );
          }
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _progressController.forward();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  String get _heightDisplay {
    if (widget.heightIsCm) {
      return '${widget.heightCm.round()}cm';
    } else {
      final totalInches = widget.heightCm / 2.54;
      final feet = (totalInches / 12).floor();
      final inches = (totalInches % 12).round();
      return '${feet}ft ${inches}in';
    }
  }

  String get _weightDisplay {
    if (widget.weightIsKg) {
      return '${widget.weightKg.toStringAsFixed(1)}kg';
    } else {
      return '${(widget.weightKg * 2.205).toStringAsFixed(1)}lb';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Logo
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Icon(Icons.self_improvement, color: AppColors.primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'FitFi Yoga',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // Title
              Text(
                'PREPARING YOUR\nYOGA PLAN',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  height: 1.2,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Crafting your personalized yoga journey...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Circular progress
              _AnimatedBuilder2(
                animation: _progressAnimation,
                builder: (context, child) {
                  final percent = (_progressAnimation.value * 100).round();
                  return SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CustomPaint(
                            painter: _CircularProgressPainter(
                              progress: _progressAnimation.value,
                              backgroundColor: const Color(0xFFE8E4DD),
                              progressColor: AppColors.primary,
                              strokeWidth: 14,
                            ),
                          ),
                        ),
                        Text(
                          '$percent%',
                          style: GoogleFonts.outfit(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 48),

              // Checklist
              _buildCheckItem(done: _step1Done,
                  text: 'Analyze your body: ', highlight: '$_heightDisplay, $_weightDisplay'),
              const SizedBox(height: 16),
              _buildCheckItem(done: _step2Done,
                  text: 'Assess flexibility level: ', highlight: 'Personalized'),
              const SizedBox(height: 16),
              _buildCheckItem(done: _step3Done,
                  text: 'Build your yoga plan', highlight: ''),
              const SizedBox(height: 16),
              _buildCheckItem(done: _step4Done,
                  text: 'Finalize your schedule', highlight: ''),

              const Spacer(flex: 2),

              // Completion message
              AnimatedOpacity(
                opacity: _allDone ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Your yoga plan is ready!',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem({
    required bool done,
    required String text,
    required String highlight,
  }) {
    return AnimatedOpacity(
      opacity: done ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 400),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: done
                ? Icon(Icons.check, color: AppColors.primary, size: 20, key: const ValueKey('done'))
                : SizedBox(
                    width: 20, height: 20,
                    key: const ValueKey('loading'),
                    child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.textSecondary,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: text,
                    style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                  ),
                  if (highlight.isNotEmpty)
                    TextSpan(
                      text: highlight,
                      style: GoogleFonts.outfit(
                        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular progress ring painter
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter old) => old.progress != progress;
}

/// AnimatedWidget wrapper for animation builder
class _AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const _AnimatedBuilder2({
    required Animation<double> animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
