import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/health_storage_service.dart';
import '../../services/progress_service.dart';
import '../../services/step_counter_service.dart';
import '../../services/water_storage_service.dart';
import '../../services/xp_service.dart';
import '../calendar_screen.dart';
import '../heart_rate_screen.dart';
import '../step_counter_screen.dart';
import '../water_tracker_screen.dart';

class AccountScreen extends StatefulWidget {
  final bool isActive;
  const AccountScreen({super.key, this.isActive = false});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  final StepCounterService _stepService = StepCounterService();
  final WaterStorageService _waterService = WaterStorageService();
  final HealthStorageService _healthService = HealthStorageService();
  final ProgressService _progressService = ProgressService();
  final XpService _xpService = XpService();

  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  _GrowthSnapshot _snapshot = const _GrowthSnapshot.empty();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    _loadGrowthSnapshot();
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AccountScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _loadGrowthSnapshot();
      _entryController.forward(from: 0);
    }
  }

  Future<void> _loadGrowthSnapshot() async {
    await _progressService.init();

    final workoutHistory = _progressService.getWorkoutHistory();
    final now = DateTime.now();

    int workoutsToday = 0;
    int totalMinutes = 0;
    int totalCalories = 0;

    for (final workout in workoutHistory) {
      final rawDate = workout['date'];
      final parsed = DateTime.tryParse('$rawDate');
      if (parsed != null &&
          parsed.year == now.year &&
          parsed.month == now.month &&
          parsed.day == now.day) {
        workoutsToday++;
      }
      totalMinutes += _asInt(workout['duration']);
      totalCalories += _asInt(workout['calories']);
    }

    final completedChallenges = _progressService.getCompletedChallenges();
    final unlockedChallengeLevel = _progressService.getUnlockedChallengeLevel();

    final challengeProgress = await _xpService.getProgress(XpDomain.challenge);
    final gymProgress = await _xpService.getProgress(XpDomain.gym);

    if (!mounted) return;
    setState(() {
      _snapshot = _GrowthSnapshot(
        workoutsToday: workoutsToday,
        totalWorkouts: workoutHistory.length,
        totalMinutes: totalMinutes,
        totalCalories: totalCalories,
        completedChallenges: completedChallenges.length,
        unlockedChallengeLevel: unlockedChallengeLevel,
        challengeProgress: challengeProgress,
        gymProgress: gymProgress,
      );
      _loading = false;
    });
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final merge = Listenable.merge([
      _stepService.stepDataNotifier,
      _waterService.waterDataNotifier,
      _healthService.healthDataNotifier,
    ]);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBFA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadGrowthSnapshot,
          color: const Color(0xFF0D9D93),
          child: AnimatedBuilder(
            animation: merge,
            builder: (context, _) {
              final stepData = _stepService.stepDataNotifier.value;
              final waterData = _waterService.waterDataNotifier.value;
              final healthData = _healthService.healthDataNotifier.value;

              final int stepGoal = StepCounterService.dailyGoal;
              final int waterGoal = max(1, waterData.dailyGoalMl);
              final int avgBpm =
                  healthData.dailyAvgBpm > 0 ? healthData.dailyAvgBpm : healthData.lastBpm;
              final int repsToday =
                  healthData.pushUps + healthData.pullUps + healthData.chinUps;

              final bool isActiveToday =
                  stepData.steps > 0 ||
                  waterData.currentIntakeMl > 0 ||
                  repsToday > 0 ||
                  _snapshot.workoutsToday > 0;

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildHeader(isActiveToday),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPrimaryStats(
                    steps: stepData.steps,
                    waterMl: waterData.currentIntakeMl,
                    avgBpm: avgBpm,
                    workoutsToday: _snapshot.workoutsToday,
                  ),
                  const SizedBox(height: 14),
                  _buildProgressCard(
                    title: 'Daily Steps',
                    subtitle: '${stepData.steps} / $stepGoal',
                    progress: (stepData.steps / stepGoal).clamp(0.0, 1.0),
                    color: const Color(0xFF0D9D93),
                    icon: Icons.directions_walk,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StepCounterScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildProgressCard(
                    title: 'Water Intake',
                    subtitle: '${waterData.currentIntakeMl}ml / $waterGoal ml',
                    progress: (waterData.currentIntakeMl / waterGoal).clamp(0.0, 1.0),
                    color: const Color(0xFF1696D2),
                    icon: Icons.water_drop,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WaterTrackerScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildStatusCard(
                    repsToday: repsToday,
                    isActiveToday: isActiveToday,
                  ),
                  const SizedBox(height: 12),
                  _buildChallengeCard(),
                  const SizedBox(height: 12),
                  _buildWorkoutSummary(),
                  const SizedBox(height: 12),
                  _buildQuickActions(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isActiveToday) {
    final now = DateTime.now();
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9D93), Color(0xFF1593C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9D93).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APP GROWTH',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${monthNames[now.month - 1]} ${now.day}, ${now.year}',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActiveToday ? Icons.bolt : Icons.hourglass_bottom,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isActiveToday ? 'ACTIVE' : 'STARTING',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Daily exercises, challenges, BPM, steps, water and workout momentum in one growth view.',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryStats({
    required int steps,
    required int waterMl,
    required int avgBpm,
    required int workoutsToday,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _StatTile(
          width: (MediaQuery.of(context).size.width - 46) / 2,
          title: 'Steps',
          value: '$steps',
          caption: 'today',
          icon: Icons.directions_walk,
          color: const Color(0xFF0D9D93),
        ),
        _StatTile(
          width: (MediaQuery.of(context).size.width - 46) / 2,
          title: 'Water',
          value: '${waterMl}ml',
          caption: 'today',
          icon: Icons.water_drop,
          color: const Color(0xFF1696D2),
        ),
        _StatTile(
          width: (MediaQuery.of(context).size.width - 46) / 2,
          title: 'Avg BPM',
          value: avgBpm > 0 ? '$avgBpm' : '--',
          caption: 'today',
          icon: Icons.favorite,
          color: const Color(0xFF15A88E),
        ),
        _StatTile(
          width: (MediaQuery.of(context).size.width - 46) / 2,
          title: 'Workouts',
          value: '$workoutsToday',
          caption: 'today',
          icon: Icons.fitness_center,
          color: const Color(0xFF147EA8),
        ),
      ],
    );
  }

  Widget _buildProgressCard({
    required String title,
    required String subtitle,
    required double progress,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF10313D),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF5E7681),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: GoogleFonts.outfit(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: progress),
              builder: (context, animatedValue, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: animatedValue,
                    backgroundColor: color.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required int repsToday,
    required bool isActiveToday,
  }) {
    final statusLabel = isActiveToday ? 'Consistency On Track' : 'Get Started Today';
    final statusSub = isActiveToday
        ? 'You are actively building growth with movement and recovery.'
        : 'No tracked movement yet. Start one exercise to unlock growth momentum.';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActiveToday ? const Color(0xFFE9F8F6) : const Color(0xFFF2F8FC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActiveToday
              ? const Color(0xFF0D9D93).withValues(alpha: 0.3)
              : const Color(0xFF1696D2).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isActiveToday ? Icons.insights : Icons.play_circle,
              color: isActiveToday ? const Color(0xFF0D9D93) : const Color(0xFF1696D2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusLabel,
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF10313D),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  statusSub,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF5E7681),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Exercise reps today: $repsToday',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF0D9D93),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF0D9D93).withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Color(0xFF0D9D93), size: 20),
              const SizedBox(width: 8),
              Text(
                'Challenges & Achievements',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF10313D),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_loading)
            const LinearProgressIndicator(minHeight: 3)
          else ...[
            _ChallengeLine(
              label: 'Completed challenge levels',
              value: '${_snapshot.completedChallenges}',
            ),
            _ChallengeLine(
              label: 'Unlocked challenge tier',
              value: '${_snapshot.unlockedChallengeLevel}',
            ),
            _ChallengeLine(
              label: 'Challenge rank',
              value: _snapshot.challengeProgress.rank,
            ),
            _ChallengeLine(
              label: 'Gym rank',
              value: _snapshot.gymProgress.rank,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkoutSummary() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1696D2).withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Summary',
            style: GoogleFonts.outfit(
              color: const Color(0xFF10313D),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  title: 'Sessions',
                  value: '${_snapshot.totalWorkouts}',
                  color: const Color(0xFF0D9D93),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryStat(
                  title: 'Minutes',
                  value: '${_snapshot.totalMinutes}',
                  color: const Color(0xFF1696D2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryStat(
                  title: 'Calories',
                  value: '${_snapshot.totalCalories}',
                  color: const Color(0xFF147EA8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.favorite,
            label: 'Heart',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HeartRateScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.water_drop,
            label: 'Water',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WaterTrackerScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.calendar_today,
            label: 'Calendar',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalendarScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GrowthSnapshot {
  final int workoutsToday;
  final int totalWorkouts;
  final int totalMinutes;
  final int totalCalories;
  final int completedChallenges;
  final int unlockedChallengeLevel;
  final XpProgress challengeProgress;
  final XpProgress gymProgress;

  const _GrowthSnapshot({
    required this.workoutsToday,
    required this.totalWorkouts,
    required this.totalMinutes,
    required this.totalCalories,
    required this.completedChallenges,
    required this.unlockedChallengeLevel,
    required this.challengeProgress,
    required this.gymProgress,
  });

  const _GrowthSnapshot.empty()
      : workoutsToday = 0,
        totalWorkouts = 0,
        totalMinutes = 0,
        totalCalories = 0,
        completedChallenges = 0,
        unlockedChallengeLevel = 10,
        challengeProgress = const XpProgress(
          xp: 0,
          level: 0,
          rank: 'UNRANKED',
          currentLevelMinXp: 0,
          nextLevelXp: 100,
        ),
        gymProgress = const XpProgress(
          xp: 0,
          level: 0,
          rank: 'UNRANKED',
          currentLevelMinXp: 0,
          nextLevelXp: 100,
        );
}

class _StatTile extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final String caption;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.width,
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xFF5E7681),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: const Color(0xFF10313D),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            caption,
            style: GoogleFonts.inter(
              color: const Color(0xFF7F97A2),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeLine extends StatelessWidget {
  final String label;
  final String value;

  const _ChallengeLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF5E7681),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: const Color(0xFF10313D),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryStat({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              color: const Color(0xFF10313D),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF5E7681),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF0D9D93).withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF0D9D93), size: 20),
            const SizedBox(height: 5),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: const Color(0xFF10313D),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
