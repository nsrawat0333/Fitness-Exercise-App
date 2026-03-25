import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/gym_challenge_data.dart';
import '../../../constants/app_colors.dart';
import 'workout_flow_screen.dart';

/// Screen that shows a 100% circular progress animation when a custom workout is generated.
class GymCustomPlanGenerationScreen extends StatefulWidget {
  final List<GymExercise> exercises;

  const GymCustomPlanGenerationScreen({
    super.key,
    required this.exercises,
  });

  @override
  State<GymCustomPlanGenerationScreen> createState() => _GymCustomPlanGenerationScreenState();
}

class _GymCustomPlanGenerationScreenState extends State<GymCustomPlanGenerationScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // 3 seconds completion
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => WorkoutFlowScreen(
                  exercises: widget.exercises,
                  dayIndex: 0,
                ),
              ),
            );
          }
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _progressController.forward();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CUSTOM PLAN\nGENERATING',
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
                'Preparing your custom exercises...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              // Circular progress indicator
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  final percent = (_progressAnimation.value * 100).round();
                  return SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background circle
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: _progressAnimation.value,
                            backgroundColor: const Color(0xFFE8E4DD),
                            color: const Color(0xFF3B82F6),
                            strokeWidth: 14,
                          ),
                        ),
                        // Percentage text
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

              const SizedBox(height: 60),

              // Completion message
              AnimatedOpacity(
                opacity: _progressAnimation.value > 0.98 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Your custom plan is ready!',
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
            ],
          ),
        ),
      ),
    );
  }
}
