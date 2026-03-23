import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import '../../../data/gym_challenge_data.dart';
import '../../../data/gym_user_data.dart';
import '../../../widgets/heart_rate_card.dart';

class GymWorkoutTimerScreen extends StatefulWidget {
  final List<GymExercise> exercises;
  final int dayIndex;

  const GymWorkoutTimerScreen({
    super.key,
    required this.exercises,
    required this.dayIndex,
  });

  @override
  State<GymWorkoutTimerScreen> createState() => _GymWorkoutTimerScreenState();
}

class _GymWorkoutTimerScreenState extends State<GymWorkoutTimerScreen> with SingleTickerProviderStateMixin {
  int _currentExerciseIndex = 0;
  
  // States: 'prepare', 'workout', 'rest', 'completed'
  String _currentState = 'prepare';
  
  int _secondsRemaining = 15; // 15s for prepare initially
  Timer? _timer;
  
  bool _isPaused = false;

  // Video player for exercises with video assets
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initVideoForCurrentState();
    _startTimerForCurrentState();
  }

  void _initVideoForCurrentState() {
    // Dispose previous controller if any
    _videoController?.dispose();
    _videoController = null;

    String? videoPath;
    if (_currentState == 'rest') {
      videoPath = 'assets/images/mp4videofolder/resttakeabreath.mp4';
    } else {
      videoPath = widget.exercises[_currentExerciseIndex].videoAsset;
    }

    if (videoPath != null) {
      _videoController = VideoPlayerController.asset(videoPath)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            _videoController!.setLooping(true);
            _videoController!.setVolume(0); // Muted autoplay
            _videoController!.play();
          }
        });
    }
  }

  void _startTimerForCurrentState() {
    if (_currentState == 'prepare') {
      _secondsRemaining = 15; // 15s preparation
    } else if (_currentState == 'workout') {
      _secondsRemaining = widget.exercises[_currentExerciseIndex].durationSeconds;
    } else if (_currentState == 'rest') {
      _secondsRemaining = 20; // 20s rest
    }
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _transitionState();
          }
        });
      }
    });
  }

  void _transitionState() {
    if (_currentState == 'prepare') {
      _currentState = 'workout';
      _startTimerForCurrentState();
    } else if (_currentState == 'workout') {
      // If it's the last exercise, complete workout instead of resting
      if (_currentExerciseIndex >= widget.exercises.length - 1) {
        _currentState = 'completed';
        _timer?.cancel();
        _videoController?.pause();
      } else {
        _currentState = 'rest';
        _initVideoForCurrentState();
        _startTimerForCurrentState();
      }
    } else if (_currentState == 'rest') {
      _currentState = 'prepare';
      _currentExerciseIndex++;
      _initVideoForCurrentState();
      _startTimerForCurrentState();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    return '00:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildVideoPlayer() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF005FF9)),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  Widget _buildCompletedDashboard() {
    int totalDurationSeconds = widget.exercises.fold(0, (sum, ex) => sum + ex.durationSeconds);
    double hours = totalDurationSeconds / 3600;
    int calories = (5.0 * GymUserData().weightKg * hours).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EC), // Base background from app
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Color(0xFF005FF9), size: 80),
                    const SizedBox(height: 16),
                    Text(
                      'WORKOUT COMPLETE!',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Day ${widget.dayIndex} Finished',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Calendar Date
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.black87, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(DateTime.now()),
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Metrics Row: Heart Rate & Calories
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: const HeartRateCard(bpm: 112)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 122, // roughly matching HeartRateCard default height
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                          const Spacer(),
                          Text('$calories', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.orange)),
                          Text('Kcal Burned', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Water Intake Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.blue, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hydration Reminder', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.blue[800])),
                          const SizedBox(height: 4),
                          Text('Great job! Drink at least 500ml water to recover.', style: GoogleFonts.inter(fontSize: 13, color: Colors.blue[600])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),
              
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

  @override
  Widget build(BuildContext context) {
    if (_currentState == 'completed') {
      return _buildCompletedDashboard();
    }

    final isRest = _currentState == 'rest';
    final isPrepare = _currentState == 'prepare';
    final activeExercise = widget.exercises[_currentExerciseIndex];
    final nextExercise = _currentExerciseIndex < widget.exercises.length - 1 
        ? widget.exercises[_currentExerciseIndex + 1] 
        : null;

    return Scaffold(
      backgroundColor: isRest ? const Color(0xFFE9EEF5) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: isRest ? Colors.black : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isRest ? 'Rest' : isPrepare ? 'Get Ready' : 'Exercise ${_currentExerciseIndex + 1}/${widget.exercises.length}',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Exercise Title Status
            Text(
              isRest ? 'Take a breather' : isPrepare ? 'GET READY\n${activeExercise.name}' : activeExercise.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            
            if (isRest && nextExercise != null) ...[
              const SizedBox(height: 8),
              Text(
                'Up Next: ${nextExercise.name}',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Video player or Lottie animation (Centered and Expanded) Full Area + Overlay Timer
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Media Background
                  Positioned.fill(
                    child: _videoController != null
                        ? _buildVideoPlayer()
                        : (!isRest && activeExercise.animationLottie != null)
                            ? Lottie.asset(
                                activeExercise.animationLottie!,
                                fit: BoxFit.contain,
                              )
                            : const SizedBox(),
                  ),

                  // Timer overlay at bottom center
                  Positioned(
                    bottom: 16,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120, // Smaller size
                          height: 120,
                          child: CircularProgressIndicator(
                            value: _secondsRemaining / (isPrepare ? 15 : isRest ? 20 : activeExercise.durationSeconds),
                            strokeWidth: 8, // Thinner stroke
                            backgroundColor: isRest ? Colors.white : const Color(0xFFE0E0E0),
                            color: isRest ? const Color(0xFF005FF9) : isPrepare ? const Color(0xFFFFA000) : const Color(0xFFFF5252),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatTime(_secondsRemaining),
                              style: GoogleFonts.outfit(
                                fontSize: 32, // Smaller font
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              isRest ? 'REST' : isPrepare ? 'PREPARE' : 'WORKOUT',
                              style: GoogleFonts.outfit(
                                fontSize: 12, // Smaller font
                                fontWeight: FontWeight.w800,
                                color: isRest ? const Color(0xFF005FF9) : isPrepare ? const Color(0xFFFFA000) : const Color(0xFFFF5252),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Skip Backward
                IconButton(
                  onPressed: () {
                    // Logic to skip backward
                    if (_currentExerciseIndex > 0) {
                      setState(() {
                        _currentExerciseIndex--;
                        _currentState = 'prepare';
                        _initVideoForCurrentState();
                        _startTimerForCurrentState();
                      });
                    }
                  },
                  icon: const Icon(Icons.skip_previous, size: 40),
                ),
                const SizedBox(width: 32),
                // Pause/Play
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPaused = !_isPaused;
                      // Sync video with pause state
                      if (_isPaused) {
                        _videoController?.pause();
                      } else {
                        _videoController?.play();
                      }
                    });
                  },
                  child: Container(
                    width: 70, // Slightly smaller control button
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Color(0xFF005FF9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                // Skip Forward
                IconButton(
                  onPressed: () {
                    // Logic to skip forward
                    setState(() {
                      _transitionState();
                    });
                  },
                  icon: const Icon(Icons.skip_next, size: 40),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
