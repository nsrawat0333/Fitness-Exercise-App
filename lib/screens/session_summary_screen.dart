import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/progress_service.dart';
import '../services/xp_service.dart';
import 'calendar_screen.dart';
import 'heart_rate_screen.dart';
import 'water_tracker_screen.dart';

class SessionSummaryScreen extends StatefulWidget {
  final String activityName;
  final int repsCompleted;
  final int targetReps;
  final int caloriesBurned;
  final bool isTimeBased;
  final bool rewardAsChallenge;

  const SessionSummaryScreen({
    super.key,
    required this.activityName,
    required this.repsCompleted,
    required this.targetReps,
    required this.caloriesBurned,
    this.isTimeBased = false,
    this.rewardAsChallenge = false,
  });

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _badgeCtrl;
  bool _pointsAwarded = false;
  XpAwardResult? _awardResult;
  XpProgress? _progress;

  @override
  void initState() {
    super.initState();
    _badgeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
        
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _badgeCtrl.forward();
      _awardPoints();
    });
  }

  @override
  void dispose() {
    _badgeCtrl.dispose();
    super.dispose();
  }

  Future<void> _awardPoints() async {
    if (_pointsAwarded) return;

    final xpService = XpService();
    late final XpAwardResult result;
    late final XpProgress progress;

    if (widget.rewardAsChallenge) {
      result = await xpService.awardChallengeExercise(
        targetValue: widget.targetReps,
        isTimeBased: widget.isTimeBased,
      );
      progress = await xpService.getProgress(XpDomain.challenge);
    } else {
      result = await xpService.awardGymSession(
        targetValue: widget.targetReps,
        completedValue: widget.repsCompleted,
        isTimeBased: widget.isTimeBased,
        caloriesBurned: widget.caloriesBurned,
      );
      progress = await xpService.getProgress(XpDomain.gym);
    }

    int durationMinutes = widget.isTimeBased
        ? (widget.repsCompleted / 60).ceil()
        : (widget.repsCompleted / 15).ceil();
    if (durationMinutes < 1) {
      durationMinutes = 1;
    }

    await ProgressService().logWorkout(
      type: widget.rewardAsChallenge ? 'challenge' : 'gym',
      name: widget.activityName,
      durationMinutes: durationMinutes,
      caloriesBurned: widget.caloriesBurned,
    );

    if (mounted) {
      setState(() {
        _pointsAwarded = true;
        _awardResult = result;
        _progress = progress;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('+${result.awardedXp} XP earned! ${widget.rewardAsChallenge ? 'Challenge' : 'Gym'} rank: ${result.afterRank}'),
          backgroundColor: AppColors.aiTargetGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (result.leveledUp) {
        _showLevelUpDialog(result.afterLevel, result.afterRank);
      }
    }
  }

  void _showLevelUpDialog(int newLevel, String newRank) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF14302A), Color(0xFF0D211D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFFFD36B), width: 1.6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFFFFD36B), size: 66),
                const SizedBox(height: 12),
                Text(
                  'LEVEL UP',
                  style: AppTextStyles.aiTitleHuge.copyWith(color: Colors.white, fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  'Level $newLevel unlocked',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  newRank,
                  style: AppTextStyles.heading3.copyWith(color: const Color(0xFFFFD36B)),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD36B),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('AWESOME'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              ScaleTransition(
                scale: CurvedAnimation(parent: _badgeCtrl, curve: Curves.elasticOut),
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: AppColors.aiTargetGreen.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events, size: 100, color: AppColors.aiTargetGreen),
                ),
              ),
              
              const SizedBox(height: 32),
              Text('Session Complete!', style: AppTextStyles.aiTitleHuge),
              const SizedBox(height: 8),
              Text(
                'You crushed your ${widget.activityName} session!',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),

              if (_awardResult != null) ...[
                const SizedBox(height: 16),
                AnimatedScale(
                  duration: const Duration(milliseconds: 350),
                  scale: 1.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.aiTargetGreen.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '+${_awardResult!.awardedXp} XP',
                      style: AppTextStyles.heading3.copyWith(color: AppColors.aiTargetGreen),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 48),
              
              // Stats Row
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 12) / 2;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: _buildStatCard(
                          widget.isTimeBased ? 'Active Time' : 'Reps',
                          '${widget.repsCompleted}/${widget.targetReps}',
                          widget.isTimeBased ? Icons.timer : Icons.fitness_center,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildStatCard('Calories', '${widget.caloriesBurned} kcal', Icons.local_fire_department),
                      ),
                    ],
                  );
                },
              ),

              if (_progress != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.aiSelectionCardBg,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${widget.rewardAsChallenge ? 'Challenge' : 'Gym'} Level ${_progress!.level}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                          const Spacer(),
                          Text(_progress!.rank, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _progress!.levelProgress,
                          minHeight: 8,
                          backgroundColor: AppColors.aiTargetGreen.withValues(alpha: 0.2),
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _progress!.isMaxLevel
                            ? 'Max level reached'
                            : '${_progress!.xp} XP total • ${_progress!.xpToNextLevel} XP to next level',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.favorite,
                      label: 'Heart',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HeartRateScreen())),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.water_drop,
                      label: 'Water',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WaterTrackerScreen())),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.calendar_today,
                      label: 'Calendar',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen())),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              GestureDetector(
                onTap: () {
                  // Pop back to home screen
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text('Continue',
                        style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.aiSelectionCardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.aiCardTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.aiSelectionCardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}
