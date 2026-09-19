import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/gym_course_model.dart';
import '../data/exercise_assets.dart';

enum WorkoutPhase { prep, action, rest }

class WorkoutPlayerScreen extends StatefulWidget {
  final String courseName;
  final List<CourseExercise> exercises;

  const WorkoutPlayerScreen({
    super.key,
    required this.courseName,
    required this.exercises,
  });

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isPlaying = false;
  
  WorkoutPhase _currentPhase = WorkoutPhase.prep;
  int _remainingSeconds = 0;
  Timer? _timer;

  // For the circular progress indicator
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    if (widget.exercises.isNotEmpty) {
      _loadExercisePhase(_currentIndex, WorkoutPhase.prep);
    }
  }

  void _loadExercisePhase(int index, WorkoutPhase phase) {
    _timer?.cancel();
    int duration = 0;
    
    switch (phase) {
      case WorkoutPhase.prep:
        duration = 20; // 20 seconds prep
        break;
      case WorkoutPhase.action:
        duration = widget.exercises[index].durationSeconds; // e.g. 30 seconds Action
        break;
      case WorkoutPhase.rest:
        duration = 10; // 10 seconds rest
        break;
    }

    setState(() {
      _currentIndex = index;
      _currentPhase = phase;
      _remainingSeconds = duration;
      _isPlaying = false;
      _progressController.value = 1.0;
    });

    // Auto-play
    _togglePlayPause();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          
          // Calculate total duration for this phase
          int totalDuration = 0;
          if (_currentPhase == WorkoutPhase.prep) {
            totalDuration = 20;
          } else if (_currentPhase == WorkoutPhase.action) {
            totalDuration = widget.exercises[_currentIndex].durationSeconds;
          } else {
            totalDuration = 10;
          }

          final double progress = totalDuration > 0 ? (_remainingSeconds / totalDuration) : 0;
          _progressController.animateTo(progress, duration: const Duration(milliseconds: 300));
        } else {
          _timer?.cancel();
          _handlePhaseComplete();
        }
      });
    });
  }

  void _handlePhaseComplete() {
    if (_currentPhase == WorkoutPhase.prep) {
      // Prep -> Action
      _loadExercisePhase(_currentIndex, WorkoutPhase.action);
    } else if (_currentPhase == WorkoutPhase.action) {
      // Action -> Check if last exercise
      if (_currentIndex < widget.exercises.length - 1) {
        _loadExercisePhase(_currentIndex, WorkoutPhase.rest); // Action -> Rest
      } else {
        _showWorkoutComplete(); // Workout Finished!
      }
    } else if (_currentPhase == WorkoutPhase.rest) {
      // Rest -> Prep of next exercise
      _loadExercisePhase(_currentIndex + 1, WorkoutPhase.prep);
    }
  }

  void _skipToNext() {
    if (_currentIndex < widget.exercises.length - 1) {
      _loadExercisePhase(_currentIndex + 1, WorkoutPhase.prep);
    } else {
      _timer?.cancel();
      _showWorkoutComplete();
    }
  }

  void _skipToPrevious() {
    if (_currentIndex > 0) {
      _loadExercisePhase(_currentIndex - 1, WorkoutPhase.prep);
    }
  }

  void _showWorkoutComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.emoji_events, color: AppColors.sageGreen, size: 60),
            SizedBox(height: 16),
            Text('WORKOUT COMPLETE!', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.sageTextDark)),
          ],
        ),
        content: Text(
          'You successfully completely all ${widget.exercises.length} exercises for ${widget.courseName}. Amazing job!',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.sageTextMuted, height: 1.5),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close player
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sageGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('DONE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
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

  String get _formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m > 0 ? '$m:' : ''}${s.toString().padLeft(2, '0')}';
  }

  // Define UI configs based on phase
  Color get _phaseColor {
    switch (_currentPhase) {
      case WorkoutPhase.prep: return Colors.orangeAccent;
      case WorkoutPhase.action: return AppColors.sageGreen;
      case WorkoutPhase.rest: return Colors.blueAccent;
    }
  }

  String get _phaseTitle {
    switch (_currentPhase) {
      case WorkoutPhase.prep: return 'PREPARE';
      case WorkoutPhase.action: return 'GO!';
      case WorkoutPhase.rest: return 'REST';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: const Center(child: Text('No exercises found.')),
      );
    }

    final currentEx = widget.exercises[_currentIndex];
    
    // During Rest phase, show the NEXT exercise's animation preview
    final viewingEx = _currentPhase == WorkoutPhase.rest 
        ? widget.exercises[_currentIndex + 1] 
        : currentEx;
        
    final assetPath = ExerciseAssets.getAssetForExercise(viewingEx.name);
    final isLast = _currentIndex == widget.exercises.length - 1;
    final nextEx = isLast ? null : widget.exercises[_currentIndex + 1];

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
                          'Exercise ${_currentIndex + 1} of ${widget.exercises.length}',
                          style: const TextStyle(color: AppColors.sageTextMuted, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          widget.courseName,
                          style: const TextStyle(color: AppColors.sageTextDark, fontSize: 16, fontWeight: FontWeight.w900),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: _phaseColor.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 10)),
                  ],
                  border: Border.all(color: _phaseColor.withValues(alpha: 0.2), width: 4),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ExerciseMediaWidget(
                      assetPath: assetPath,
                      fit: BoxFit.contain,
                    ),
                    if (_currentPhase == WorkoutPhase.rest)
                      Container(
                        color: Colors.black.withValues(alpha: 0.4),
                        child: const Center(
                          child: Icon(Icons.self_improvement, color: Colors.white54, size: 80),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── TIMER / CONTROLS ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _phaseTitle,
                      key: ValueKey(_phaseTitle),
                      style: TextStyle(
                        color: _phaseColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentPhase == WorkoutPhase.rest ? 'Up next: ${viewingEx.name.toUpperCase()}' : currentEx.name.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.sageTextDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Previous BTN
                      IconButton(
                        onPressed: _currentIndex > 0 ? _skipToPrevious : null,
                        icon: Icon(Icons.skip_previous, size: 36, color: _currentIndex > 0 ? AppColors.sageGreen : AppColors.sageGreenLight),
                      ),

                      // TIMER CIRCLE
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 140,
                              child: AnimatedBuilder(
                                animation: _progressController,
                                builder: (context, child) {
                                  return CircularProgressIndicator(
                                    value: _progressController.value,
                                    strokeWidth: 10,
                                    backgroundColor: AppColors.sageGreenLight.withValues(alpha: 0.5),
                                    valueColor: AlwaysStoppedAnimation<Color>(_phaseColor),
                                  );
                                },
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formattedTime,
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.sageTextDark,
                                    height: 1.0,
                                  ),
                                ),
                                Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: AppColors.sageTextMuted,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Next BTN
                      IconButton(
                        onPressed: _skipToNext,
                        icon: const Icon(Icons.skip_next, size: 36, color: AppColors.sageGreen),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── UP NEXT ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(Icons.arrow_forward_rounded, color: AppColors.sageTextMuted, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Queue:',
                    style: TextStyle(color: AppColors.sageTextMuted, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      nextEx != null ? nextEx.name : 'Workout Complete 🎉',
                      style: const TextStyle(color: AppColors.sageTextDark, fontWeight: FontWeight.w800, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
