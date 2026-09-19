import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/challenge_model.dart';
import '../../data/exercise_assets.dart';
import '../../services/progress_service.dart';
import '../../services/xp_service.dart';
import '../calendar_screen.dart';
import '../ai_activity_screen.dart';
import '../heart_rate_screen.dart';
import '../water_tracker_screen.dart';

class ChallengePlayerScreen extends StatefulWidget {
  final ChallengeLevel level;

  const ChallengePlayerScreen({super.key, required this.level});

  @override
  State<ChallengePlayerScreen> createState() => _ChallengePlayerScreenState();
}

class _ChallengePlayerScreenState extends State<ChallengePlayerScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _remainingSeconds = 20;
  Timer? _timer;
  bool _isLaunchingCamera = false;
  final _progressService = ProgressService();
  final _xpService = XpService();

  // The circular progress for the prep phase
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    if (widget.level.exercises.isNotEmpty) {
      _loadPrepPhase(_currentIndex);
    }
  }

  void _loadPrepPhase(int index) {
    _timer?.cancel();
    setState(() {
      _currentIndex = index;
      _remainingSeconds = 20; // 20 seconds prep
      _progressController.value = 1.0;
    });
    _startPrepTimer();
  }

  void _startPrepTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          final double progress = _remainingSeconds / 20;
          _progressController.animateTo(progress, duration: const Duration(milliseconds: 300));
        } else {
          _timer?.cancel();
          _launchAiCamera();
        }
      });
    });
  }

  Future<void> _launchAiCamera() async {
    if (_isLaunchingCamera) return;
    _timer?.cancel();
    _isLaunchingCamera = true;

    try {
      final currentEx = widget.level.exercises[_currentIndex];

      // Determine target based on type
      int target = 20;
      if (currentEx.type == ChallengeExerciseType.rep) {
        target = currentEx.targetReps;
      } else {
        target = currentEx.targetSeconds;
      }

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AiActivityScreen(
            initialActivity: currentEx.name,
            targetOverride: target,
            isChallengeMode: true,
            challengeExerciseType: currentEx.type,
            challengeExerciseId: currentEx.exerciseId,
          ),
        ),
      );
      // If result == true, they completed it!
      if (result == true && mounted) {
        final targetValue = currentEx.type == ChallengeExerciseType.rep
            ? currentEx.targetReps
            : currentEx.targetSeconds;
        final xpResult = await _xpService.awardChallengeExercise(
          targetValue: targetValue,
          isTimeBased: currentEx.type != ChallengeExerciseType.rep,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('+${xpResult.awardedXp} Challenge XP'),
              duration: const Duration(milliseconds: 900),
              backgroundColor: const Color(0xFF1D5F52),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        if (xpResult.leveledUp && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Level Up! L${xpResult.afterLevel} • ${xpResult.afterRank}'),
              duration: const Duration(milliseconds: 1100),
              backgroundColor: Colors.deepOrange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        _nextExercise();
      } else if (mounted) {
        // User exited the AI camera — show exit/retry dialog
        _timer?.cancel();
        _showExitDialog();
      }
    } finally {
      _isLaunchingCamera = false;
    }
  }

  void _nextExercise() {
    if (_currentIndex < widget.level.exercises.length - 1) {
      _timer?.cancel();
      _loadPrepPhase(_currentIndex + 1);
    } else {
      _showChallengeComplete();
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
            SizedBox(height: 12),
            Text(
              'EXIT CHALLENGE?',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const Text(
          'Your progress will not be saved. The challenge will restart from the beginning next time.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, height: 1.5),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              _launchAiCamera(); // retry same exercise immediately
            },
            child: const Text(
              'RETRY',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // exit challenge player
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text(
              'EXIT',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showChallengeComplete() async {
    await _progressService.completeChallenge(widget.level.exerciseCount);
    int estMinutes = widget.level.exercises.length * 2;
    if (estMinutes < 1) estMinutes = 1;
    await _progressService.logWorkout(
      type: 'challenge',
      name: widget.level.name,
      durationMinutes: estMinutes,
      caloriesBurned: widget.level.exercises.length * 12,
    );

    final milestone = await _xpService.awardChallengeMilestone(
      challengeSize: widget.level.exerciseCount,
    );
    final progress = await _xpService.getProgress(XpDomain.challenge);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            const Icon(Icons.whatshot, color: Colors.orange, size: 60),
            const SizedBox(height: 16),
            Text('CHALLENGE BEATEN!', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.sageTextDark)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You successfully completed the ${widget.level.name} challenge.\n\n'
              '+${milestone.awardedXp} Challenge XP\n'
              'Level ${progress.level} • ${progress.rank}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.sageTextMuted, height: 1.5),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.favorite, size: 16),
                  label: const Text('Heart'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HeartRateScreen()));
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.water_drop, size: 16),
                  label: const Text('Water'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const WaterTrackerScreen()));
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.calendar_today, size: 16),
                  label: const Text('Calendar'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context, true); // close player and send success
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('CLAIM REWARD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.level.exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Challenge')),
        body: const Center(child: Text('No exercises found.')),
      );
    }

    final currentEx = widget.level.exercises[_currentIndex];
    final assetPath = ExerciseAssets.getAssetForExercise(currentEx.name);
    
    // Parse color for theme
    Color themeColor = Colors.orange;
    try {
      themeColor = Color(int.parse(widget.level.auraColor.replaceFirst('#', '0xFF')));
    } catch (_) {}

    return Scaffold(
      backgroundColor: AppColors.sageBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP BAR ──
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.sageTextDark),
                    onPressed: () {
                      _timer?.cancel();
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Exercise ${_currentIndex + 1} of ${widget.level.exercises.length}',
                          style: const TextStyle(color: AppColors.sageTextMuted, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          widget.level.name,
                          style: const TextStyle(color: AppColors.sageTextDark, fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48), // balance back button
                ],
              ),
            ),

            // ── MEDIA DISPLAY ──
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                  border: Border.all(color: themeColor.withValues(alpha: 0.3), width: 3),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ExerciseMediaWidget(
                      assetPath: assetPath,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      top: 16, left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.camera_alt, color: Colors.white, size: 14),
                            SizedBox(width: 6),
                            Text('Camera tracks this move', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── PREP UI ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Text(
                    'PREPARE',
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentEx.name.toUpperCase(),
                    style: const TextStyle(color: AppColors.sageTextDark, fontSize: 20, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // TIMER CIRCLE
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final timerSize = (constraints.maxWidth * 0.42).clamp(112.0, 150.0);
                      final timerTextSize = (timerSize * 0.34).clamp(36.0, 48.0);
                      final ringWidth = (timerSize * 0.07).clamp(8.0, 10.0);

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: timerSize,
                            height: timerSize,
                            child: AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, child) {
                                return CircularProgressIndicator(
                                  value: _progressController.value,
                                  strokeWidth: ringWidth,
                                  backgroundColor: AppColors.sageGreenLight.withValues(alpha: 0.5),
                                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                );
                              },
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_remainingSeconds',
                                style: TextStyle(
                                  fontSize: timerTextSize,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.sageTextDark,
                                ),
                              ),
                              const Text(
                                'sec preview',
                                style: TextStyle(color: AppColors.sageTextMuted, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Quick start button
                  TextButton(
                    onPressed: _launchAiCamera,
                    child: Text('SKIP PREVIEW', style: TextStyle(color: themeColor, fontWeight: FontWeight.w800)),
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
