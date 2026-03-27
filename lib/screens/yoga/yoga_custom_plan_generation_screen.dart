import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/yoga_service.dart';
import '../gym/courses/workout_flow_screen.dart';
import '../../data/gym_challenge_data.dart';

class YogaCustomPlanGenerationScreen extends StatefulWidget {
  final String level;
  final String goal;
  final int durationMinutes;

  const YogaCustomPlanGenerationScreen({
    super.key,
    required this.level,
    required this.goal,
    required this.durationMinutes,
  });

  @override
  State<YogaCustomPlanGenerationScreen> createState() => _YogaCustomPlanGenerationScreenState();
}

class _YogaCustomPlanGenerationScreenState extends State<YogaCustomPlanGenerationScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  bool _step1Done = false;
  bool _step2Done = false;
  bool _step3Done = false;
  bool _step4Done = false;
  bool _allDone = false;

  List<GymExercise>? _generatedExercises;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
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
        
        // Generate plan in background
        _generatePlan();

        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted && _generatedExercises != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => WorkoutFlowScreen(
                  exercises: _generatedExercises!,
                  dayIndex: 0,
                ),
              ),
            );
          }
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _progressController.forward();
    });
  }

  void _generatePlan() {
    final session = YogaService.generateCustomPlan(
      level: widget.level,
      goal: widget.goal,
      durationMinutes: widget.durationMinutes,
    );

    _generatedExercises = session.poses.map((p) {
      return GymExercise(
        id: p.name.toLowerCase().replaceAll(' ', '_'),
        name: p.name,
        category: p.category,
        muscleGroup: p.focusAreas,
        difficulty: session.difficulty,
        durationSeconds: p.durationSeconds,
        performDuration: p.durationSeconds,
        previewDuration: 20,
        instructions: p.steps,
        imageAsset: p.image.isNotEmpty ? p.image : GymChallengeData.getFallbackImage(p.name),
        animationLottie: p.animation.isNotEmpty ? p.animation : null,
      );
    }).toList();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Logo / Header
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Color(0xFF7C4DFF), size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'AI Custom Flow',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF7C4DFF),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // Title
              Text(
                'CURATING YOUR\nPERFECT FLOW',
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
                'Designing a ${widget.durationMinutes}-minute flow for ${widget.goal}...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Circular progress
              _AnimatedBuilder3(
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
                            painter: _CircularProgressPainter2(
                              progress: _progressAnimation.value,
                              backgroundColor: const Color(0xFFE8E4DD),
                              progressColor: const Color(0xFF7C4DFF),
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
              _buildCheckItem(done: _step1Done, text: 'Analyzing experience: ', highlight: widget.level),
              const SizedBox(height: 16),
              _buildCheckItem(done: _step2Done, text: 'Selecting poses for: ', highlight: widget.goal),
              const SizedBox(height: 16),
              _buildCheckItem(done: _step3Done, text: 'Optimizing flow for ${widget.durationMinutes} mins', highlight: ''),
              const SizedBox(height: 16),
              _buildCheckItem(done: _step4Done, text: 'Generating AI commentary', highlight: ''),

              const Spacer(flex: 2),

              // Completion message
              AnimatedOpacity(
                opacity: _allDone ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C4DFF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF7C4DFF), size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Your custom flow is ready!',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7C4DFF),
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
      opacity: done ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 400),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: done
                ? const Icon(Icons.check, color: Color(0xFF7C4DFF), size: 20, key: ValueKey('done'))
                : const SizedBox(
                    width: 20, height: 20,
                    key: ValueKey('loading'),
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
                        fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF7C4DFF),
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
class _CircularProgressPainter2 extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _CircularProgressPainter2({
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
  bool shouldRepaint(covariant _CircularProgressPainter2 old) => old.progress != progress;
}

/// AnimatedWidget wrapper for animation builder
class _AnimatedBuilder3 extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;

  const _AnimatedBuilder3({
    required Animation<double> animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
