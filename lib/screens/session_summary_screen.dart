import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/gamification_service.dart';

class SessionSummaryScreen extends StatefulWidget {
  final String activityName;
  final int repsCompleted;
  final int targetReps;
  final int caloriesBurned;

  const SessionSummaryScreen({
    super.key,
    required this.activityName,
    required this.repsCompleted,
    required this.targetReps,
    required this.caloriesBurned,
  });

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _badgeCtrl;
  bool _pointsAwarded = false;

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
    
    // Base 50 points for completing a workout
    int points = 50; 
    
    // Bonus for reaching target
    if (widget.repsCompleted >= widget.targetReps) {
      points += 50;
    }

    await GamificationService().awardPoints(points, '${widget.activityName} Session');
    
    if (mounted) {
      setState(() {
        _pointsAwarded = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('+$points Points Earned! 🎉 Streak Extended!'),
          backgroundColor: AppColors.aiTargetGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
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
              
              const SizedBox(height: 48),
              
              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('Reps', '${widget.repsCompleted}/${widget.targetReps}', Icons.fitness_center),
                  _buildStatCard('Calories', '${widget.caloriesBurned} kcal', Icons.local_fire_department),
                ],
              ),
              
              const Spacer(),
              
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
      width: 140,
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
}
