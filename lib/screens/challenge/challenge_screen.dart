import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../data/challenge_data.dart';
import '../../data/exercise_assets.dart';
import '../../models/challenge_model.dart';
import '../../services/progress_service.dart';
import '../../services/xp_service.dart';
import '../ai_activity_screen.dart';
import 'challenge_detail_screen.dart';

/// Image mapping for challenge levels
const _challengeImages = {
  10: 'assets/sections/challange/10 wale ka.jpg',
  20: 'assets/sections/challange/20.jpg',
  30: 'assets/sections/challange/30.jpg',
  50: 'assets/sections/challange/50.jpg',
  60: 'assets/sections/challange/60.jpg',
  100: 'assets/sections/challange/100.jpg',
};

class _FooterChallengeExercise {
  final String name;
  final String exerciseId;
  final ChallengeExerciseType type;
  final IconData icon;
  final String subtitle;

  const _FooterChallengeExercise({
    required this.name,
    required this.exerciseId,
    required this.type,
    required this.icon,
    required this.subtitle,
  });
}

const List<_FooterChallengeExercise> _footerChallengeExercises = [
  _FooterChallengeExercise(
    name: 'Push-Ups',
    exerciseId: 'push_ups',
    type: ChallengeExerciseType.rep,
    icon: Icons.fitness_center,
    subtitle: 'Upper body strength',
  ),
  _FooterChallengeExercise(
    name: 'Pull-Ups',
    exerciseId: 'pull_ups',
    type: ChallengeExerciseType.rep,
    icon: Icons.accessibility_new,
    subtitle: 'Back and arms power',
  ),
  _FooterChallengeExercise(
    name: 'Squats',
    exerciseId: 'squats',
    type: ChallengeExerciseType.rep,
    icon: Icons.directions_run,
    subtitle: 'Leg strength builder',
  ),
  _FooterChallengeExercise(
    name: 'Lunges',
    exerciseId: 'lunges',
    type: ChallengeExerciseType.rep,
    icon: Icons.directions_walk,
    subtitle: 'Balance and legs',
  ),
  _FooterChallengeExercise(
    name: 'Crunches',
    exerciseId: 'abdominal_crunches',
    type: ChallengeExerciseType.rep,
    icon: Icons.sports_martial_arts,
    subtitle: 'Core shaping rep set',
  ),
  _FooterChallengeExercise(
    name: 'Burpees',
    exerciseId: 'burpees',
    type: ChallengeExerciseType.rep,
    icon: Icons.flash_on,
    subtitle: 'Full-body explosive reps',
  ),
  _FooterChallengeExercise(
    name: 'Jump Squats',
    exerciseId: 'jump_squats',
    type: ChallengeExerciseType.rep,
    icon: Icons.air,
    subtitle: 'Power legs and cardio',
  ),
  _FooterChallengeExercise(
    name: 'Tricep Dips',
    exerciseId: 'tricep_dips',
    type: ChallengeExerciseType.rep,
    icon: Icons.fitness_center,
    subtitle: 'Arm endurance reps',
  ),
  _FooterChallengeExercise(
    name: 'Russian Twist',
    exerciseId: 'russian_twists',
    type: ChallengeExerciseType.rep,
    icon: Icons.rotate_right,
    subtitle: 'Oblique core reps',
  ),
  _FooterChallengeExercise(
    name: 'Leg Raises',
    exerciseId: 'leg_raises',
    type: ChallengeExerciseType.rep,
    icon: Icons.straighten,
    subtitle: 'Lower abs reps',
  ),
  _FooterChallengeExercise(
    name: 'Plank',
    exerciseId: 'plank',
    type: ChallengeExerciseType.time,
    icon: Icons.horizontal_rule,
    subtitle: 'Static core hold',
  ),
  _FooterChallengeExercise(
    name: 'Side Plank',
    exerciseId: 'side_plank',
    type: ChallengeExerciseType.time,
    icon: Icons.swap_horiz,
    subtitle: 'Oblique hold balance',
  ),
  _FooterChallengeExercise(
    name: 'Wall Sit',
    exerciseId: 'wall_sit',
    type: ChallengeExerciseType.time,
    icon: Icons.crop_landscape,
    subtitle: 'Leg endurance hold',
  ),
  _FooterChallengeExercise(
    name: 'High Knees',
    exerciseId: 'high_knees',
    type: ChallengeExerciseType.time,
    icon: Icons.speed,
    subtitle: 'Cardio pace hold mode',
  ),
  _FooterChallengeExercise(
    name: 'Jumping Jacks',
    exerciseId: 'jumping_jacks',
    type: ChallengeExerciseType.time,
    icon: Icons.open_with,
    subtitle: 'Rhythm and stamina time',
  ),
];

String? _resolveChallengeExerciseAsset(_FooterChallengeExercise exercise) {
  return ExerciseAssets.getAssetForExercise(exercise.name) ??
      ExerciseAssets.getAssetForExercise(
        exercise.exerciseId.replaceAll('_', ' '),
      );
}

/// Main Challenge tab — shows 6 ranked challenge levels
class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final _progress = ProgressService();
  final _xpService = XpService();
  int _unlockedLevel = 10;
  List<int> _completed = [];
  XpProgress? _challengeProgress;

  Future<void> _openQuickChallenge(_FooterChallengeExercise exercise) async {
    final isRep = exercise.type == ChallengeExerciseType.rep;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiActivityScreen(
          initialActivity: exercise.name,
          challengeExerciseType: exercise.type,
          challengeExerciseId: exercise.exerciseId,
          forceTimeBased: !isRep,
          targetOptions: isRep ? const [10, 20, 30] : const [5, 10, 20],
          targetValuesAreMinutes: !isRep,
          customTargetUnitLabel: isRep ? 'REPS' : 'MIN',
          rewardAsChallenge: true,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    await _progress.init();
    final challengeXp = await _xpService.getProgress(XpDomain.challenge);
    setState(() {
      _unlockedLevel = _progress.getUnlockedChallengeLevel();
      _completed = _progress.getCompletedChallenges();
      _challengeProgress = challengeXp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final levels = ChallengeData.getAllLevels();

    return Scaffold(
      backgroundColor: AppColors.sageBg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHALLENGE',
                      style: AppTextStyles.sageTitle.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Final ranking: 10 Junior Trainee to 100 UFC Fighter.',
                      style: AppTextStyles.sageSubtitle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            if (_challengeProgress != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Challenge Level ${_challengeProgress!.level}',
                              style: AppTextStyles.sageTitle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _challengeProgress!.rank,
                              style: AppTextStyles.sageTitle.copyWith(
                                fontSize: 13,
                                color: AppColors.sageGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            minHeight: 8,
                            value: _challengeProgress!.levelProgress,
                            backgroundColor: AppColors.sageGreenLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.sageGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _challengeProgress!.isMaxLevel
                              ? '${_challengeProgress!.xp} XP • Max rank unlocked'
                              : '${_challengeProgress!.xp} XP • ${_challengeProgress!.xpToNextLevel} XP to next level',
                          style: AppTextStyles.sageSubtitle.copyWith(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final level = levels[index];
                  final isUnlocked =
                      level.exerciseCount <= _unlockedLevel ||
                      level.exerciseCount >= 20;
                  final isCompleted = _completed.contains(level.exerciseCount);

                  return _ChallengeLevelCard(
                    level: level,
                    imagePath: _challengeImages[level.exerciseCount],
                    isUnlocked: isUnlocked,
                    isCompleted: isCompleted,
                    onTap: isUnlocked
                        ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChallengeDetailScreen(level: level),
                            ),
                          ).then((_) => _loadProgress())
                        : null,
                  );
                }, childCount: levels.length),
              ),
            ),
            // Individual challenges section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INDIVIDUAL CHALLENGES',
                      style: AppTextStyles.sageTitle.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '15 quick challenges in interactive cards with unique images.',
                      style: AppTextStyles.sageSubtitle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.82,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final exercise = _footerChallengeExercises[index];
                  return _IndividualChallengeCard(
                    exercise: exercise,
                    index: index,
                    onTap: () => _openQuickChallenge(exercise),
                  );
                }, childCount: _footerChallengeExercises.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

class _ChallengeLevelCard extends StatelessWidget {
  final ChallengeLevel level;
  final String? imagePath;
  final bool isUnlocked;
  final bool isCompleted;
  final VoidCallback? onTap;

  const _ChallengeLevelCard({
    required this.level,
    this.imagePath,
    required this.isUnlocked,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.sageGreen;
    if (level.auraColor.contains('B71C1C')) {
      color = const Color(0xFFC04F4F);
    }
    if (level.auraColor.contains('D50000')) {
      color = const Color(0xFFC43333);
    } else if (level.auraColor.contains('FF5722')) {
      color = const Color(0xFFCE603A);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 140,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (imagePath != null)
              ColorFiltered(
                colorFilter: isUnlocked
                    ? const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.multiply,
                      )
                    : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                child: Image.asset(
                  imagePath!,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, _, _) =>
                      Container(color: AppColors.sageGreenLight),
                ),
              ),
            // Light vignette
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            // Lock overlay for locked levels
            if (!isUnlocked)
              Container(color: Colors.white.withValues(alpha: 0.7)),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Level number circle
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isUnlocked
                          ? Colors.white
                          : AppColors.sageGreenLight,
                      boxShadow: isUnlocked
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(Icons.check, color: color, size: 28)
                          : Text(
                              '${level.exerciseCount}',
                              style: TextStyle(
                                color: isUnlocked
                                    ? color
                                    : AppColors.sageTextMuted,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          level.name,
                          style: TextStyle(
                            color: isUnlocked
                                ? Colors.white
                                : AppColors.sageTextMuted,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          level.tagline,
                          style: TextStyle(
                            color: isUnlocked
                                ? Colors.white.withValues(alpha: 0.8)
                                : AppColors.sageTextMuted,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? color
                                : AppColors.sageGreenLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${level.exerciseCount} exercises',
                            style: TextStyle(
                              color: isUnlocked
                                  ? Colors.white
                                  : AppColors.sageTextMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isUnlocked
                        ? (isCompleted
                              ? Icons.emoji_events
                              : Icons.arrow_forward_ios)
                        : Icons.lock_outline,
                    color: isUnlocked ? Colors.white : AppColors.sageTextMuted,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndividualChallengeCard extends StatelessWidget {
  final _FooterChallengeExercise exercise;
  final int index;
  final VoidCallback onTap;

  const _IndividualChallengeCard({
    required this.exercise,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRep = exercise.type == ChallengeExerciseType.rep;
    final typeColor = isRep ? AppColors.sageGreen : const Color(0xFF2C90C6);
    final typeLabel = isRep ? 'REP' : 'TIME';
    final imagePath = _resolveChallengeExerciseAsset(exercise);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 260 + (index * 35)),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 14),
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ExerciseMediaWidget(
                    assetPath: imagePath,
                    fit: BoxFit.cover,
                    isThumbnail: true,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.12),
                          Colors.black.withValues(alpha: 0.78),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        typeLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(exercise.icon, color: Colors.white, size: 15),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                exercise.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exercise.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.86),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Start challenge',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: typeColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
