import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/user_model.dart';
import '../widgets/fitfi_app_bar.dart';
import '../widgets/step_counter_widget.dart';
import '../widgets/water_tracker_card.dart';
import '../widgets/heart_rate_card.dart';
import '../widgets/ai_detection_card.dart';
import '../widgets/therapy_card.dart';
import 'step_counter_screen.dart';

/// Main home screen of the FitFi app.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserModel.mock();

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // ── App Bar ──
              const FitfiAppBar(),

              const SizedBox(height: 20),

              // ── Greeting ──
              Text(
                'READY, ${user.name.toUpperCase()}',
                style: AppTextStyles.greeting,
              ),

              const SizedBox(height: 20),

              // ── Step Counter ──
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const StepCounterScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.15),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: FadeTransition(opacity: animation, child: child),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                },
                child: StepCounterWidget(
                  steps: user.steps,
                  goal: user.stepGoal,
                ),
              ),

              const SizedBox(height: 20),

              // ── Water + Heart Rate Row ──
              SizedBox(
                height: 170,
                child: Row(
                  children: [
                    Expanded(
                      child: WaterTrackerCard(
                        glasses: user.waterGlasses,
                        goal: user.waterGoal,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: HeartRateCard(bpm: user.heartRate),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── AI Detection ──
              AiDetectionCard(
                pushUps: user.pushUps,
                pullUps: user.pullUps,
                chinUps: user.chinUps,
              ),

              const SizedBox(height: 20),

              // ── Therapy Card ──
              const TherapyCard(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
