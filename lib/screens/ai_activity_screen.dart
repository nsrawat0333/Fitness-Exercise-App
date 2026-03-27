
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../data/hindi_exercise_instructions.dart';
import '../services/pose_detection_service.dart';
import '../services/rep_counter_service.dart';
import '../services/health_storage_service.dart';
import '../services/voice_coach_service.dart';
import '../services/music_service.dart';
import 'session_summary_screen.dart';

enum AiActivityState { selection, target, permission, camera, result }

/// Screen showcasing the AI Detection Activity flow.
/// It cycles through: Selection -> Target -> Permission -> Camera -> Result.
class AiActivityScreen extends StatefulWidget {
  final String? initialActivity;

  const AiActivityScreen({super.key, this.initialActivity});

  @override
  State<AiActivityScreen> createState() => _AiActivityScreenState();
}

class _AiActivityScreenState extends State<AiActivityScreen>
    with TickerProviderStateMixin {
  AiActivityState _currentState = AiActivityState.selection;

  // Selections
  String? _selectedActivity;
  int _selectedTarget = 20; // Default

  // Camera & AI Services
  CameraController? _cameraController;
  final _poseService = PoseDetectionService();
  final _repService = RepCounterService();
  final _voiceCoach = VoiceCoachService();
  final _musicService = MusicService();
  bool _isCameraReady = false;
  int _lastAnnouncedRep = 0;
  int _lastFrameTimeMs = 0;
  bool _useFrontCamera = false; // Back camera by default for push-ups
  List<Pose> _currentPoses = []; // Real ML Kit poses for skeleton overlay
  int _sensorOrientation = 0;

  late AnimationController _cameraPulseCtrl;

  @override
  void initState() {
    super.initState();
    _cameraPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _voiceCoach.init();
    _musicService.init();

    if (widget.initialActivity != null) {
      _selectedActivity = widget.initialActivity;
      _currentState = AiActivityState.target;
    }
  }

  @override
  void dispose() {
    _cameraPulseCtrl.dispose();
    _voiceCoach.stop();
    _musicService.stop();
    _cameraController?.dispose();
    _poseService.dispose();
    _repService.trackingNotifier.dispose();
    super.dispose();
  }

  // ── Flow Actions ──

  void _onActivitySelected(String activity) {
    setState(() {
      _selectedActivity = activity;
      _currentState = AiActivityState.target;
    });
  }

  void _onStartRoutine() {
    setState(() {
      _currentState = AiActivityState.permission;
    });
  }

  void _onGrantPermission() async {
    // ── BUG FIX 1: Actually request camera permission ──
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required for AI tracking'), backgroundColor: Colors.red),
        );
      }
      return; // Stay on permission screen
    }

    setState(() {
      _currentState = AiActivityState.camera;
    });
    
    _repService.reset();
    _lastAnnouncedRep = 0;
    
    // Speak exercise start instructions
    final data = HindiExerciseInstructions.getInstructions(
      (_selectedActivity ?? 'push-ups').toLowerCase(),
    );
    if (data != null) {
      _voiceCoach.speakSequence(data.start);
    }
    
    // NO background music during camera AI exercises — only AI voice coaching
    
    // ── BUG FIX 2 & 3: Try-catch camera init + use back camera for push-ups ──
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No camera found on this device'), backgroundColor: Colors.red),
          );
          setState(() => _currentState = AiActivityState.permission);
        }
        return;
      }

      // Default to BACK camera for floor-based exercises (push-ups)
      final targetLens = _useFrontCamera ? CameraLensDirection.front : CameraLensDirection.back;
      final selectedCamera = cameras.firstWhere(
        (c) => c.lensDirection == targetLens,
        orElse: () => cameras.first,
      );
      _sensorOrientation = selectedCamera.sensorOrientation;
      
      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      
      await _cameraController!.initialize();
      if (!mounted) return;
      
      setState(() {
        _isCameraReady = true;
      });
      
      _cameraController!.startImageStream((image) async {
        final currentTimeMs = DateTime.now().millisecondsSinceEpoch;
        // Throttle to max 5 FPS to prevent CPU overload:
        if (currentTimeMs - _lastFrameTimeMs < 200) return;
        _lastFrameTimeMs = currentTimeMs;

        final poses = await _poseService.processCameraFrame(image, _sensorOrientation);
        if (mounted) {
          // ── BUG FIX 4: Store real poses for skeleton overlay ──
          setState(() {
            _currentPoses = poses;
          });
        }
        
        if (poses.isNotEmpty && mounted) {
          _repService.processPose(poses.first, _selectedActivity ?? 'Push-ups');
          
          // Announce reps dynamically
          final currentReps = _repService.trackingNotifier.value.reps;
          if (currentReps > _lastAnnouncedRep) {
            _lastAnnouncedRep = currentReps;
            if (currentReps % 5 == 0) {
              _voiceCoach.speak(HindiExerciseInstructions.repMilestone(currentReps));
            } else {
              _voiceCoach.speak(HindiExerciseInstructions.repCompleted(currentReps, _selectedTarget));
            }
          }
          
          // Check if goal reached
          if (_repService.trackingNotifier.value.reps >= _selectedTarget) {
            _cameraController?.stopImageStream();
            
            HealthStorageService().addWorkoutReps(_selectedActivity ?? 'Push-ups', _selectedTarget);
            int calories = _selectedTarget * 2;
            
            if (!mounted) return;
            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => SessionSummaryScreen(
                  activityName: _selectedActivity ?? 'Push-ups',
                  repsCompleted: _selectedTarget,
                  targetReps: _selectedTarget,
                  caloriesBurned: calories,
                ),
              ),
            );
          }
        }
      });
    } catch (e) {
      debugPrint('Camera init error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e'), backgroundColor: Colors.red),
        );
        setState(() => _currentState = AiActivityState.permission);
      }
    }
  }

  void _toggleCamera() async {
    _cameraController?.stopImageStream();
    await _cameraController?.dispose();
    setState(() {
      _isCameraReady = false;
      _useFrontCamera = !_useFrontCamera;
    });
    _onGrantPermission();
  }

  void _resetFlow() {
    _cameraController?.stopImageStream();
    setState(() {
      _currentState = AiActivityState.selection;
      _selectedActivity = null;
      _isCameraReady = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold background changes when camera starts
    final isCamera = _currentState == AiActivityState.camera;
    final bgColor = isCamera ? AppColors.aiCameraBg : AppColors.scaffoldBg;

    return Scaffold(
      backgroundColor: bgColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        color: bgColor,
        child: SafeArea(
          child: Column(
            children: [
              if (!isCamera) _buildAppBar(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _buildCurrentState(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final showBack = _currentState != AiActivityState.result;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: () {
                if (_currentState == AiActivityState.target) {
                  setState(() => _currentState = AiActivityState.selection);
                } else if (_currentState == AiActivityState.permission) {
                  setState(() => _currentState = AiActivityState.target);
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 24),
            )
          else
            const SizedBox(width: 24),
            
          const Expanded(
            child: Center(
              child: Text('Restorative Oasis',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
            ),
          ),
          const SizedBox(width: 24), // Balance spacing
        ],
      ),
    );
  }

  Widget _buildCurrentState() {
    switch (_currentState) {
      case AiActivityState.selection:
        return _buildSelectionState(key: const ValueKey('selection'));
      case AiActivityState.target:
        return _buildTargetState(key: const ValueKey('target'));
      case AiActivityState.permission:
        return _buildPermissionState(key: const ValueKey('permission'));
      case AiActivityState.camera:
        return _buildCameraState(key: const ValueKey('camera'));
      case AiActivityState.result:
        return _buildResultState(key: const ValueKey('result'));
    }
  }

  // ══════════════════════════════════════════════════════════════
  // STATE 1: SELECTION UI
  // ══════════════════════════════════════════════════════════════
  Widget _buildSelectionState({required Key key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TRAINING JOURNEY', style: AppTextStyles.aiSubtitle),
          const SizedBox(height: 8),
          Text('Select Focus', style: AppTextStyles.aiTitleHuge),
          const SizedBox(height: 40),
          _buildActivityCard(
            title: 'Push-ups',
            icon: Icons.fitness_center,
            iconColor: AppColors.primary,
          ),
          const SizedBox(height: 20),
          _buildActivityCard(
            title: 'Pull-ups',
            icon: Icons.accessibility_new,
            iconColor: const Color(0xFF8B5A2B), // Brownish
          ),
          const SizedBox(height: 20),
          _buildActivityCard(
            title: 'Chin-ups',
            icon: Icons.sports_gymnastics,
            iconColor: const Color(0xFF6B4242), // Maroon
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Focus on form and controlled movements for optimal\nmuscular engagement. Your oasis for restorative strength.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 10, height: 1.6),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 40, height: 1, color: AppColors.textMuted.withValues(alpha: 0.5)),
              const SizedBox(width: 12),
              Text('SELECT TO BEGIN SESSION',
                  style: TextStyle(fontSize: 10, color: AppColors.textMuted, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required IconData icon,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: () => _onActivitySelected(title),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36),
        decoration: BoxDecoration(
          color: AppColors.aiSelectionCardBg,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: iconColor),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTextStyles.aiCardTitle),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // STATE 2: TARGET SETUP UI
  // ══════════════════════════════════════════════════════════════
  Widget _buildTargetState({required Key key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(_selectedActivity ?? 'Activity', style: AppTextStyles.aiTitleHuge),
          const SizedBox(height: 4),
          Text('SET YOUR TARGET', style: AppTextStyles.aiSubtitle),
          
          const SizedBox(height: 40),
          
          // Image Placeholder Header
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(40),
                  image: const DecorationImage(
                    // Simulated placeholder image using standard Flutter icon/color if image missing
                    image: NetworkImage('https://images.unsplash.com/photo-1598971639058-fab3c3109a00?q=80&w=800&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department, size: 14, color: AppColors.aiTargetGreen),
                      const SizedBox(width: 4),
                      Text('Target Energy',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 40),

          // Target Selectors
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTargetOption(10, 'MAINTAIN'),
              _buildTargetOption(20, 'RECOMMENDED'),
              _buildTargetOption(30, 'CHALLENGE'),
            ],
          ),

          const SizedBox(height: 40),

          Text(
            'Consistency is key. Focus on your form and\nkeep a steady breathing rhythm through all\n$_selectedTarget repetitions.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(height: 1.6),
          ),

          const SizedBox(height: 32),

          GestureDetector(
            onTap: _onStartRoutine,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.aiTargetGreen,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.aiTargetGreen.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Start Routine',
                      style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                  const SizedBox(width: 12),
                  const Icon(Icons.play_arrow, color: Colors.white),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('SKIP TODAY', style: AppTextStyles.aiTargetLabel),
              const SizedBox(width: 20),
              Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle)),
              const SizedBox(width: 20),
              Text('HISTORY', style: AppTextStyles.aiTargetLabel),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTargetOption(int target, String label) {
    bool isSelected = _selectedTarget == target;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTarget = target;
        });
      },
      child: Column(
        children: [
          Text(label,
              style: AppTextStyles.aiTargetLabel.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textMuted)),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSelected ? 120 : 100,
            height: isSelected ? 120 : 100,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.aiTargetGreen : AppColors.aiTargetGrey,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: Text(
                target.toString(),
                style: AppTextStyles.aiTargetValue.copyWith(
                  color: isSelected ? AppColors.textPrimary : AppColors.textPrimary,
                  fontSize: isSelected ? 48 : 36,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // STATE 3: PERMISSION UI
  // ══════════════════════════════════════════════════════════════
  Widget _buildPermissionState({required Key key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.aiSelectionCardBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, size: 64, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            Text('Camera Access', style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            Text(
              'We need access to your camera to enable AI pose detection and accurately count your reps.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _onGrantPermission,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text('Grant Access',
                      style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => setState(() => _currentState = AiActivityState.target),
              child: Text('Not Now', style: AppTextStyles.actionLink),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // STATE 4: CAMERA UI (SIMULATION)
  // ══════════════════════════════════════════════════════════════
  Widget _buildCameraState({required Key key}) {
    return Container(
      key: key,
      color: AppColors.aiCameraBg, 
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Live Camera Preview
          if (_isCameraReady && _cameraController != null)
            Positioned.fill(
              child: RotatedBox(
                quarterTurns: 0,
                child: AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            )
          else
            Positioned.fill(
               child: Center(
                 child: Icon(Icons.videocam, size: 80, color: Colors.white.withValues(alpha: 0.05)),
               ), 
            ),

          // 2. Real ML Kit Pose Skeleton Overlay
          if (_currentPoses.isNotEmpty)
            Positioned.fill(
              child: CustomPaint(
                painter: _RealPosePainter(
                  poses: _currentPoses,
                  imageSize: _cameraController != null && _isCameraReady
                    ? Size(
                        _cameraController!.value.previewSize?.height ?? 480,
                        _cameraController!.value.previewSize?.width ?? 640,
                      )
                    : const Size(480, 640),
                ),
              ),
            )
          else
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.15),
              ),
            ),

           // 3. UI Header
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _cameraController?.stopImageStream();
                        setState(() => _currentState = AiActivityState.target);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Camera flip button
                    GestureDetector(
                      onTap: _toggleCamera,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.cameraswitch, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _currentPoses.isNotEmpty ? AppColors.aiActiveDot : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                            color: _currentPoses.isNotEmpty ? Colors.white : Colors.black, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(_currentPoses.isNotEmpty ? 'AI Tracking' : 'Searching...',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Live Reps Counter & Feedback
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: ValueListenableBuilder<RepCounterData>(
              valueListenable: _repService.trackingNotifier,
              builder: (context, trackingData, _) {
                return Column(
                  children: [
                    Text('${trackingData.reps} / $_selectedTarget',
                        style: TextStyle(fontSize: 84, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                    Text('REPS COMPLETED',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 2.0, color: AppColors.aiActiveDot)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.aiActiveDot.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        trackingData.feedback,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // STATE 5: RESULT UI
  // ══════════════════════════════════════════════════════════════
  Widget _buildResultState({required Key key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.aiTargetGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events, size: 80, color: AppColors.aiTargetGreen),
            ),
            const SizedBox(height: 40),
            Text('Great Job!', style: AppTextStyles.aiTitleHuge),
            const SizedBox(height: 16),
            Text(
              'You successfully completed $_selectedTarget $_selectedActivity.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _resetFlow,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.aiTargetGreen,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text('Done',
                      style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// REAL POSE PAINTER — Draws actual ML Kit landmarks
// ══════════════════════════════════════════════════════════════

class _RealPosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;

  _RealPosePainter({required this.poses, required this.imageSize});

  @override
  void paint(Canvas canvas, Size size) {
    if (poses.isEmpty) return;

    final paintLine = Paint()
      ..color = const Color(0xFF00E676) // Bright green
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final paintJoint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final paintGlow = Paint()
      ..color = const Color(0xFF00E676).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Scale factors from image coordinates to canvas coordinates
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    for (final pose in poses) {
      final landmarks = pose.landmarks;

      // Helper to get scaled offset
      Offset? getPoint(PoseLandmarkType type) {
        final lm = landmarks[type];
        if (lm == null) return null;
        return Offset(lm.x * scaleX, lm.y * scaleY);
      }

      // Draw skeletal connections
      void drawBone(PoseLandmarkType from, PoseLandmarkType to) {
        final a = getPoint(from);
        final b = getPoint(to);
        if (a != null && b != null) {
          canvas.drawLine(a, b, paintLine);
        }
      }

      // Upper body
      drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
      drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
      drawBone(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
      drawBone(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
      drawBone(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);

      // Torso
      drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
      drawBone(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
      drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);

      // Lower body
      drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
      drawBone(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
      drawBone(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
      drawBone(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);

      // Draw joint circles for all visible landmarks
      for (final entry in landmarks.entries) {
        final point = Offset(entry.value.x * scaleX, entry.value.y * scaleY);
        canvas.drawCircle(point, 10, paintGlow); // Outer glow
        canvas.drawCircle(point, 5, paintJoint); // Inner dot
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RealPosePainter old) => true;
}

