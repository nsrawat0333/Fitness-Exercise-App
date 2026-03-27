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
import 'ai_activity_screen.dart';
import 'heart_rate_screen.dart';
import 'step_counter_screen.dart';
import 'water_tracker_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/water_storage_service.dart';
import '../models/water_intake_model.dart';
import '../services/health_storage_service.dart';
import '../services/step_counter_service.dart';
import '../services/points_manager.dart';

/// Main home screen of the FitFi app.
class HomeScreen extends StatelessWidget {
  final Function(int)? onTabChange;

  const HomeScreen({super.key, this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final user = UserModel.mock();
    final stepService = StepCounterService();

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
              FitfiAppBar(
                onProfileTap: () {
                  if (onTabChange != null) {
                    onTabChange!(4); // Switch to Account Tab
                  }
                },
                onNotificationTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No new notifications'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // ── Sync Status ──
              ValueListenableBuilder<SyncStatus>(
                valueListenable: PointsManager().syncStatus,
                builder: (context, status, child) {
                  if (status == SyncStatus.synced) {
                    return const SizedBox.shrink(); // Hide if synced
                  }
                  
                  bool isSyncing = status == SyncStatus.syncing;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSyncing ? Colors.blue.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSyncing ? Colors.blue.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSyncing)
                          const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                        else
                          const Icon(Icons.cloud_off, size: 14, color: Colors.orange),
                        const SizedBox(width: 6),
                        Text(
                          isSyncing ? 'Syncing Activity...' : 'Offline - Data Saved Locally',
                          style: GoogleFonts.inter(fontSize: 12, color: isSyncing ? Colors.blue[800] : Colors.orange[800], fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              // ── Greeting ──
              Text(
                'READY, ${FirebaseAuth.instance.currentUser?.displayName?.toUpperCase() ?? "TESTER"}',
                style: AppTextStyles.greeting,
              ),

              const SizedBox(height: 20),

              // ── Step Counter ──
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, _, _) => const StepCounterScreen(),
                      transitionsBuilder: (_, animation, _, child) {
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
                child: ValueListenableBuilder<StepData>(
                  valueListenable: stepService.stepDataNotifier,
                  builder: (context, stepData, child) {
                    return StepCounterWidget(
                      steps: stepData.steps,
                      goal: user.stepGoal,
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── Water + Heart Rate Row ──
              SizedBox(
                height: 170,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, _, _) =>
                                  const WaterTrackerScreen(),
                              transitionsBuilder:
                                  (_, animation, _, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.15),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutCubic,
                                  )),
                                  child: FadeTransition(
                                      opacity: animation, child: child),
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                            ),
                          );
                        },
                        child: ValueListenableBuilder<WaterIntakeModel>(
                          valueListenable: WaterStorageService().waterDataNotifier,
                          builder: (context, waterData, _) {
                            // Convert ml to "glasses" (roughly 250ml per glass)
                            int glasses = (waterData.currentIntakeMl / 250).round();
                            int goalGlasses = (waterData.dailyGoalMl / 250).round();
                            // prevent divide by zero or infinite
                            if (goalGlasses == 0) goalGlasses = 8;
                            
                            return WaterTrackerCard(
                              glasses: glasses,
                              goal: goalGlasses,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, _, _) =>
                                  const HeartRateScreen(),
                              transitionsBuilder:
                                  (_, animation, _, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.15),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutCubic,
                                  )),
                                  child: FadeTransition(
                                      opacity: animation, child: child),
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                            ),
                          );
                        },
                        child: ValueListenableBuilder<HealthData>(
                          valueListenable: HealthStorageService().healthDataNotifier,
                          builder: (context, healthData, _) {
                            return HeartRateCard(bpm: healthData.lastBpm);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Quick Exercise ──
              _buildQuickExercises(context),
              const SizedBox(height: 20),

              // ── AI Detection ──
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, _, _) => const AiActivityScreen(),
                      transitionsBuilder: (_, animation, _, child) {
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
                child: ValueListenableBuilder<HealthData>(
                  valueListenable: HealthStorageService().healthDataNotifier,
                  builder: (context, healthData, _) {
                    return AiDetectionCard(
                      pushUps: healthData.pushUps,
                      pullUps: healthData.pullUps,
                      chinUps: healthData.chinUps,
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── Therapy Card ──
              GestureDetector(
                onTap: () {
                  if (onTabChange != null) {
                    onTabChange!(2); // 2 is the index for Therapy tab
                  }
                },
                child: const TherapyCard(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickExercises(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Exercise',
          style: AppTextStyles.sageTitle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildExerciseCard(context, 'Push-ups', Icons.fitness_center),
              _buildExerciseCard(context, 'Pull-ups', Icons.accessibility_new),
              _buildExerciseCard(context, 'Chin-ups', Icons.sports_gymnastics),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AiActivityScreen(initialActivity: title),
          ),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.sageGreen, size: 28),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyles.sageSubtitle.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.sageTextDark)),
          ],
        ),
      ),
    );
  }
}
