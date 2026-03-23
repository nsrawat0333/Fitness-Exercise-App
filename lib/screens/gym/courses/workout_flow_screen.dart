import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import '../../../data/gym_challenge_data.dart';
import '../../../data/gym_user_data.dart';
import '../../../widgets/breathing_animation_widget.dart';
import '../../../widgets/heart_rate_card.dart';

/// Workout phase enum for the 5-phase flow.
enum WorkoutPhase {
  breathing,    // Phase 1: Relaxation & Breathing (20s)
  preview,      // Phase 2: Exercise Preview (20s)
  perform,      // Phase 3: Exercise Performance (30s)
  recovery,     // Phase 4: Post-Exercise Breathing (20s)
  nextPreview,  // Phase 5: Next Exercise Preview (20s)
}

/// Full 5-phase workout flow screen.
/// Replaces the old GymWorkoutTimerScreen with smooth transitions.
class WorkoutFlowScreen extends StatefulWidget {
  final List<GymExercise> exercises;
  final int dayIndex;

  const WorkoutFlowScreen({
    super.key,
    required this.exercises,
    required this.dayIndex,
  });

  @override
  State<WorkoutFlowScreen> createState() => _WorkoutFlowScreenState();
}

class _WorkoutFlowScreenState extends State<WorkoutFlowScreen>
    with TickerProviderStateMixin {
  int _currentExerciseIndex = 0;
  WorkoutPhase _currentPhase = WorkoutPhase.breathing;
  int _secondsRemaining = 20;
  Timer? _timer;
  bool _isPaused = false;
  bool _isCompleted = false;

  // Video player for exercises with video assets
  VideoPlayerController? _videoController;

  // Phase transition animation
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeOutCubic),
    );

    _transitionController.forward();
    _startPhase();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController?.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  GymExercise get _currentExercise => widget.exercises[_currentExerciseIndex];
  GymExercise? get _nextExercise =>
      _currentExerciseIndex < widget.exercises.length - 1
          ? widget.exercises[_currentExerciseIndex + 1]
          : null;

  bool get _isLastExercise =>
      _currentExerciseIndex >= widget.exercises.length - 1;

  int _getDurationForPhase(WorkoutPhase phase) {
    switch (phase) {
      case WorkoutPhase.breathing:
        return _currentExercise.breathingDuration;
      case WorkoutPhase.preview:
        return _currentExercise.previewDuration;
      case WorkoutPhase.perform:
        return _currentExercise.performDuration;
      case WorkoutPhase.recovery:
        return _currentExercise.recoveryDuration;
      case WorkoutPhase.nextPreview:
        return 20;
    }
  }

  void _startPhase() {
    _secondsRemaining = _getDurationForPhase(_currentPhase);
    _initMediaForPhase();
    _startTimer();
  }

  void _initMediaForPhase() {
    _videoController?.dispose();
    _videoController = null;

    String? videoPath;
    if (_currentPhase == WorkoutPhase.perform) {
      videoPath = _currentExercise.videoAsset;
    } else if (_currentPhase == WorkoutPhase.recovery ||
        _currentPhase == WorkoutPhase.breathing) {
      videoPath = 'assets/images/mp4videofolder/resttakeabreath.mp4';
    }

    // Only use video for perform phase, breathing uses the custom widget
    if (_currentPhase == WorkoutPhase.perform && videoPath != null) {
      _videoController = VideoPlayerController.asset(videoPath)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            _videoController!.setLooping(true);
            _videoController!.setVolume(0);
            _videoController!.play();
          }
        });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;
      if (!mounted) return;

      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _transitionToNextPhase();
        }
      });
    });
  }

  Future<void> _animateTransition() async {
    await _transitionController.reverse();
    if (mounted) {
      _transitionController.forward();
    }
  }
 
  void _transitionToNextPhase() {
    _timer?.cancel();

    switch (_currentPhase) {
      case WorkoutPhase.breathing:
        _currentPhase = WorkoutPhase.preview;
        break;
      case WorkoutPhase.preview:
        _currentPhase = WorkoutPhase.perform;
        break;
      case WorkoutPhase.perform:
        if (_isLastExercise) {
          // No recovery/next preview for last exercise → complete
          setState(() => _isCompleted = true);
          _videoController?.pause();
          return;
        }
        _currentPhase = WorkoutPhase.recovery;
        break;
      case WorkoutPhase.recovery:
        if (_nextExercise != null) {
          _currentPhase = WorkoutPhase.nextPreview;
        } else {
          setState(() => _isCompleted = true);
          return;
        }
        break;
      case WorkoutPhase.nextPreview:
        // Move to next exercise
        _currentExerciseIndex++;
        _currentPhase = WorkoutPhase.breathing;
        break;
    }

    _animateTransition();
    _startPhase();
    setState(() {});
  }

  void _skipForward() {
    _transitionToNextPhase();
  }

  void _skipBackward() {
    if (_currentPhase != WorkoutPhase.breathing) {
      // Go back to start of current exercise
      _currentPhase = WorkoutPhase.breathing;
    } else if (_currentExerciseIndex > 0) {
      _currentExerciseIndex--;
      _currentPhase = WorkoutPhase.breathing;
    }
    _animateTransition();
    _startPhase();
    setState(() {});
  }

  // ── Phase Colors & Labels ──

  Color get _phaseColor {
    switch (_currentPhase) {
      case WorkoutPhase.breathing:
        return const Color(0xFF5B7E5F);
      case WorkoutPhase.preview:
        return const Color(0xFFFFA000);
      case WorkoutPhase.perform:
        return const Color(0xFFFF5252);
      case WorkoutPhase.recovery:
        return const Color(0xFF5EC6C6);
      case WorkoutPhase.nextPreview:
        return const Color(0xFF7C4DFF);
    }
  }

  Color get _phaseBgColor {
    switch (_currentPhase) {
      case WorkoutPhase.breathing:
        return const Color(0xFFF0F7F0);
      case WorkoutPhase.preview:
        return const Color(0xFFFFF8E1);
      case WorkoutPhase.perform:
        return Colors.white;
      case WorkoutPhase.recovery:
        return const Color(0xFFE8F8F8);
      case WorkoutPhase.nextPreview:
        return const Color(0xFFF3EFFF);
    }
  }

  String get _phaseLabel {
    switch (_currentPhase) {
      case WorkoutPhase.breathing:
        return 'BREATHING';
      case WorkoutPhase.preview:
        return 'GET READY';
      case WorkoutPhase.perform:
        return 'WORKOUT';
      case WorkoutPhase.recovery:
        return 'RECOVERY';
      case WorkoutPhase.nextPreview:
        return 'UP NEXT';
    }
  }

  String get _phaseTitle {
    switch (_currentPhase) {
      case WorkoutPhase.breathing:
        return 'Relax & Breathe';
      case WorkoutPhase.preview:
        return _currentExercise.name;
      case WorkoutPhase.perform:
        return _currentExercise.name;
      case WorkoutPhase.recovery:
        return 'Recovery Time';
      case WorkoutPhase.nextPreview:
        return _nextExercise?.name ?? 'Complete!';
    }
  }

  IconData get _phaseIcon {
    switch (_currentPhase) {
      case WorkoutPhase.breathing:
        return Icons.self_improvement;
      case WorkoutPhase.preview:
        return Icons.visibility;
      case WorkoutPhase.perform:
        return Icons.fitness_center;
      case WorkoutPhase.recovery:
        return Icons.spa;
      case WorkoutPhase.nextPreview:
        return Icons.skip_next;
    }
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // ── Build Methods ──

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      return _buildCompletedDashboard();
    }

    return Scaffold(
      backgroundColor: _phaseBgColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _buildTopBar(),
                _buildPhaseIndicator(),
                const SizedBox(height: 8),
                _buildPhaseTitle(),
                const SizedBox(height: 16),
                Expanded(child: _buildPhaseContent()),
                _buildTimer(),
                const SizedBox(height: 16),
                _buildControls(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showExitDialog(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.close, color: Colors.black87, size: 22),
            ),
          ),
          const Spacer(),
          // Exercise counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _phaseColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentExerciseIndex + 1} / ${widget.exercises.length}',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _phaseColor,
              ),
            ),
          ),
          const Spacer(),
          // Phase icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _phaseColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_phaseIcon, color: _phaseColor, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: WorkoutPhase.values.where((p) => p != WorkoutPhase.nextPreview).map((phase) {
          final isActive = phase == _currentPhase ||
              (_currentPhase == WorkoutPhase.nextPreview &&
                  phase == WorkoutPhase.recovery);
          final isPast = phase.index < _currentPhase.index;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isPast
                    ? _phaseColor
                    : isActive
                        ? _phaseColor.withValues(alpha: 0.7)
                        : Colors.black.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPhaseTitle() {
    return Column(
      children: [
        // Phase label badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: _phaseColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _phaseLabel,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: _phaseColor,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _phaseTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ),
        // Subtitle for preview/perform phases
        if (_currentPhase == WorkoutPhase.preview) ...[
          const SizedBox(height: 6),
          Text(
            'Prepare Yourself',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (_currentPhase == WorkoutPhase.nextPreview && _nextExercise != null) ...[
          const SizedBox(height: 6),
          Text(
            'Coming up next...',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPhaseContent() {
    switch (_currentPhase) {
      case WorkoutPhase.breathing:
        return _buildBreathingContent(
          color: const Color(0xFF5B7E5F),
          glowColor: const Color(0xFF52B788),
          label: 'Relax & Breathe',
        );
      case WorkoutPhase.preview:
        return _buildPreviewContent(_currentExercise);
      case WorkoutPhase.perform:
        return _buildPerformContent();
      case WorkoutPhase.recovery:
        return _buildBreathingContent(
          color: const Color(0xFF5EC6C6),
          glowColor: const Color(0xFF3BA8A8),
          label: 'Recovery Breathing',
        );
      case WorkoutPhase.nextPreview:
        return _nextExercise != null
            ? _buildPreviewContent(_nextExercise!)
            : const Center(child: Icon(Icons.check_circle, size: 80, color: Colors.green));
    }
  }

  Widget _buildBreathingContent({
    required Color color,
    required Color glowColor,
    required String label,
  }) {
    return Center(
      child: BreathingAnimationWidget(
        color: color,
        glowColor: glowColor,
        size: 220,
        label: label,
      ),
    );
  }

  Widget _buildPreviewContent(GymExercise exercise) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animation
          if (exercise.animationLottie != null)
            SizedBox(
              height: 250,
              child: Lottie.asset(
                exercise.animationLottie!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildExercisePlaceholder(exercise);
                },
              ),
            )
          else
            _buildExercisePlaceholder(exercise),
          const SizedBox(height: 20),
          // Instructions
          if (exercise.instructions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                exercise.instructions.first,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExercisePlaceholder(GymExercise exercise) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: _phaseColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: _phaseColor.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            exercise.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _phaseColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformContent() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Video or Lottie
        if (_videoController != null && _videoController!.value.isInitialized)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          )
        else if (_currentExercise.animationLottie != null)
          Lottie.asset(
            _currentExercise.animationLottie!,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildExercisePlaceholder(_currentExercise);
            },
          )
        else
          _buildExercisePlaceholder(_currentExercise),

        // Instructions overlay at bottom
        if (_currentExercise.instructions.isNotEmpty)
          Positioned(
            bottom: 16,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _currentExercise.instructions.join(' • '),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTimer() {
    final totalDuration = _getDurationForPhase(_currentPhase);
    final progress = totalDuration > 0
        ? _secondsRemaining / totalDuration
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Circular timer
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.black.withValues(alpha: 0.06),
                  color: _phaseColor,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(_secondsRemaining),
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    _phaseLabel,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _phaseColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Skip Backward
        GestureDetector(
          onTap: _skipBackward,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.skip_previous_rounded, size: 28, color: Colors.black54),
          ),
        ),
        const SizedBox(width: 28),
        // Pause / Play
        GestureDetector(
          onTap: () {
            setState(() {
              _isPaused = !_isPaused;
              if (_isPaused) {
                _videoController?.pause();
              } else {
                _videoController?.play();
              }
            });
          },
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: _phaseColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _phaseColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
        ),
        const SizedBox(width: 28),
        // Skip Forward
        GestureDetector(
          onTap: _skipForward,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.skip_next_rounded, size: 28, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Quit Workout?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Your progress will be lost.',
          style: GoogleFonts.inter(color: Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Stay', style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              color: _phaseColor,
            )),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close workout
            },
            child: Text('Quit', style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              color: Colors.red,
            )),
          ),
        ],
      ),
    );
  }

  // ── Completion Dashboard (preserved from original) ──

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  Widget _buildCompletedDashboard() {
    int totalDurationSeconds = widget.exercises.fold(0, (sum, ex) => sum + ex.durationSeconds);
    double hours = totalDurationSeconds / 3600;
    int calories = (5.0 * GymUserData().weightKg * hours).round();
    final userData = GymUserData();
    double bmi = userData.bmi;
    String bmiCategory = userData.bmiCategory;

    if (widget.dayIndex > 0) {
      userData.completeDay(widget.dayIndex);
    }

    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstWeekday = DateTime(now.year, now.month, 1).weekday;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF005FF9).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle, color: Color(0xFF005FF9), size: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'WORKOUT COMPLETE!',
                      style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.black),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.dayIndex > 0 ? 'Day ${widget.dayIndex} Finished' : 'Custom Workout Finished',
                      style: GoogleFonts.inter(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // BMI + Kcal Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 130,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bmi < 25
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.monitor_weight_outlined,
                            color: bmi < 25 ? Colors.green : Colors.orange, size: 26),
                          const Spacer(),
                          Text(
                            bmi.toStringAsFixed(1),
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: bmi < 25 ? Colors.green[700] : Colors.orange[700],
                            ),
                          ),
                          Text('BMI • $bmiCategory',
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      height: 130,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.orange, size: 26),
                          const Spacer(),
                          Text('$calories',
                            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.orange)),
                          Text('Kcal Burned',
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Heart Rate + Duration
              Row(
                children: [
                  Expanded(child: const HeartRateCard(bpm: 112)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      height: 122,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.timer, color: Color(0xFF9C27B0), size: 26),
                          const Spacer(),
                          Text(
                            '${(totalDurationSeconds / 60).round()}',
                            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFF9C27B0)),
                          ),
                          Text('Minutes',
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Water Intake
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.blue, size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hydration Reminder',
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.blue[800])),
                          const SizedBox(height: 3),
                          Text('Drink at least 500ml water to recover.',
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.blue[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Calendar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8E4DD)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.black87, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(now),
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'].map((d) => SizedBox(
                        width: 32,
                        child: Text(d, textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[500])),
                      )).toList(),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      children: List.generate(firstWeekday - 1, (_) => const SizedBox(width: 46, height: 32))
                        + List.generate(daysInMonth, (i) {
                          int day = i + 1;
                          bool isToday = day == now.day;
                          return SizedBox(
                            width: 46,
                            height: 32,
                            child: Center(
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: isToday ? const BoxDecoration(
                                  color: Color(0xFF005FF9),
                                  shape: BoxShape.circle,
                                ) : null,
                                alignment: Alignment.center,
                                child: Text(
                                  '$day',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                    color: isToday ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Finish Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) {
                      return route.settings.name == '/home' || route.isFirst;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005FF9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    'FINISH',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
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
