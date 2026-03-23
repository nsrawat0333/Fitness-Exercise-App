import 'dart:async';

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

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
  int _currentReps = 0;

  // Animations
  late AnimationController _cameraPulseCtrl;
  Timer? _simulatedTimer;

  @override
  void initState() {
    super.initState();
    _cameraPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    if (widget.initialActivity != null) {
      _selectedActivity = widget.initialActivity;
      _currentState = AiActivityState.target;
    }
  }

  @override
  void dispose() {
    _cameraPulseCtrl.dispose();
    _simulatedTimer?.cancel();
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

  void _onGrantPermission() {
    setState(() {
      _currentState = AiActivityState.camera;
      _currentReps = 0;
    });
    _startSimulation();
  }

  void _startSimulation() {
    // Simulates an ML detection callback every 2-3 seconds
    _simulatedTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (mounted && _currentState == AiActivityState.camera) {
        setState(() {
          _currentReps++;
          if (_currentReps >= _selectedTarget) {
            timer.cancel();
            _currentState = AiActivityState.result;
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resetFlow() {
    setState(() {
      _currentState = AiActivityState.selection;
      _selectedActivity = null;
      _currentReps = 0;
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
      color: AppColors.aiCameraBg, // Dark background
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Simulated Camera View Finder
          Positioned.fill(
             child: Center(
               child: Icon(Icons.videocam, size: 80, color: Colors.white.withValues(alpha: 0.05)),
             ), 
          ),

          // 2. Simulated Pose Detection Overlay (Skeleton)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _cameraPulseCtrl,
              builder: (context, child) {
                return CustomPaint(
                  painter: _SkeletonPainter(pulse: _cameraPulseCtrl.value),
                );
              },
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
                GestureDetector(
                  onTap: () {
                    _simulatedTimer?.cancel();
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.aiActiveDot,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      const Text('AI Analyzing',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Reps Counter
          Positioned(
            bottom: 60,
            left: 60,
            right: 60,
            child: Column(
              children: [
                Text('$_currentReps / $_selectedTarget',
                    style: TextStyle(fontSize: 84, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                Text('REPS COMPLETED',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 2.0, color: AppColors.aiActiveDot)),
              ],
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
// CUSTOM PAINTER (SKELETON)
// ══════════════════════════════════════════════════════════════

/// Simulates a MediaPipe / OpenCV skeleton overlay tracking a person.
class _SkeletonPainter extends CustomPainter {
  final double pulse;
  _SkeletonPainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    // Generate a simulated skeleton roughly in the center
    final cx = size.width / 2;
    final cy = size.height / 2 - 40;

    final paintLine = Paint()
      ..color = AppColors.aiActiveDot.withValues(alpha: 0.6 + (0.4 * pulse))
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final paintJoint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final paintGlow = Paint()
      ..color = AppColors.aiActiveDot.withValues(alpha: 0.3 * pulse)
      ..style = PaintingStyle.fill;

    // Simulated points (simplified upper body)
    final head = Offset(cx, cy - 80);
    final neck = Offset(cx, cy - 30);
    final leftShoulder = Offset(cx - 60, cy - 20);
    final rightShoulder = Offset(cx + 60, cy - 20);
    final leftElbow = Offset(cx - 80, cy + 40);
    final rightElbow = Offset(cx + 80, cy + 40);
    final leftWrist = Offset(cx - 60, cy + 100);
    final rightWrist = Offset(cx + 60, cy + 100);
    final spine = Offset(cx, cy + 90);
    final leftHip = Offset(cx - 40, cy + 110);
    final rightHip = Offset(cx + 40, cy + 110);

    // Draw lines
    canvas.drawLine(head, neck, paintLine);
    canvas.drawLine(neck, leftShoulder, paintLine);
    canvas.drawLine(neck, rightShoulder, paintLine);
    canvas.drawLine(leftShoulder, leftElbow, paintLine);
    canvas.drawLine(rightShoulder, rightElbow, paintLine);
    canvas.drawLine(leftElbow, leftWrist, paintLine);
    canvas.drawLine(rightElbow, rightWrist, paintLine);
    canvas.drawLine(neck, spine, paintLine);
    canvas.drawLine(spine, leftHip, paintLine);
    canvas.drawLine(spine, rightHip, paintLine);

    // Draw joints
    final points = [head, neck, leftShoulder, rightShoulder, leftElbow, rightElbow, leftWrist, rightWrist, spine, leftHip, rightHip];
    for (var p in points) {
      canvas.drawCircle(p, 12 + (4 * pulse), paintGlow); // Outer glow
      canvas.drawCircle(p, 6, paintJoint); // Inner node
    }
  }

  @override
  bool shouldRepaint(covariant _SkeletonPainter old) => old.pulse != pulse;
}
