import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../ai_activity_screen.dart';

enum RunState { idle, running, paused }

class ActiveRunScreen extends StatefulWidget {
  final String goalTitle;

  const ActiveRunScreen({super.key, required this.goalTitle});

  @override
  State<ActiveRunScreen> createState() => _ActiveRunScreenState();
}

class _ActiveRunScreenState extends State<ActiveRunScreen> {
  RunState _state = RunState.idle;
  int _elapsedSeconds = 0;
  double _distanceKm = 0.0;
  final double _targetDistanceKm = 7.0;
  Timer? _timer;

  void _startTimer() {
    setState(() => _state = RunState.running);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _elapsedSeconds++;
        // Simulate distance progression
        _distanceKm += 0.02;
        if (_distanceKm >= _targetDistanceKm) {
          _distanceKm = _targetDistanceKm;
          _finishSession();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() => _state = RunState.paused);
    _timer?.cancel();
  }

  void _finishSession() {
    _timer?.cancel();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _openExercise(String activity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiActivityScreen(initialActivity: activity),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _avgPace {
    if (_distanceKm == 0) return '--:--';
    final paceSeconds = (_elapsedSeconds / _distanceKm).floor();
    final m = (paceSeconds ~/ 60).toString();
    final s = (paceSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_distanceKm / _targetDistanceKm).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.sageMapBg,
      body: Stack(
        children: [
          // ── MAP BACKGROUND PAINTER ──
          // TODO: Replace with Google Maps API
          Positioned.fill(
            child: Container(
              color: const Color(0xFFE8ECE1), // Distinct map-like base color
              child: CustomPaint(
                painter: _SageMapPainter(progress: progress),
              ),
            ),
          ),

          // ── TOP METRICS OVERLAY ──
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.sageGreenLight.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.goalTitle.toUpperCase(),
                          style: AppTextStyles.sageSubtitle.copyWith(
                            color: AppColors.sageGreen,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Progression Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _distanceKm.toStringAsFixed(2),
                        style: AppTextStyles.sageTitle.copyWith(fontSize: 48),
                      ),
                      const SizedBox(width: 8),
                      Text('km', style: AppTextStyles.sageSubtitle.copyWith(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 8,
                      color: AppColors.sageBg,
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.sageGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(_formattedTime, style: AppTextStyles.sageTitle.copyWith(fontSize: 24)),
                          Text('Time', style: AppTextStyles.sageSubtitle),
                        ],
                      ),
                      Container(width: 1, height: 40, color: AppColors.sageBg),
                      Column(
                        children: [
                          Text('$_avgPace /km', style: AppTextStyles.sageTitle.copyWith(fontSize: 24)),
                          Text('Avg Pace', style: AppTextStyles.sageSubtitle),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── BOTTOM FLOATING AREA ──
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_state == RunState.idle) _buildQuickExercises(),
                const SizedBox(height: 16),

                // Session Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildSessionControls(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickExercises() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Quick Warm-up',
            style: AppTextStyles.sageTitle.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: [
              _buildExerciseCard('Push-ups', Icons.fitness_center),
              _buildExerciseCard('Pull-ups', Icons.accessibility_new),
              _buildExerciseCard('Chin-ups', Icons.sports_gymnastics),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(String title, IconData icon) {
    return GestureDetector(
      onTap: () => _openExercise(title),
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.sageGreen, size: 28),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyles.sageSubtitle.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.sageTextDark)),
          ],
        ),
      ),
    );
  }


  Widget _buildSessionControls() {
    if (_state == RunState.idle) {
      return GestureDetector(
        onTap: _startTimer,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.sageGreen,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: AppColors.sageGreen.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: Center(
            child: Text(
              'Start Run',
              style: AppTextStyles.sageCardTitle.copyWith(fontSize: 20, letterSpacing: 0.5),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if (_state == RunState.running) {
                _pauseTimer();
              } else {
                _startTimer();
              }
            },
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: _state == RunState.running ? Colors.white : AppColors.sageGreen,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _state == RunState.running ? Icons.pause : Icons.play_arrow,
                      color: _state == RunState.running ? Colors.black : Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _state == RunState.running ? 'Pause' : 'Resume',
                      style: AppTextStyles.sageCardTitle.copyWith(
                        color: _state == RunState.running ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: _finishSession,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.sageDark,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.stop, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('Finish', style: AppTextStyles.sageCardTitle),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── CUSTOM SAGE MAP PAINTER (MULTIPLE FLAGS + WAYPOINTS) ──
class _SageMapPainter extends CustomPainter {
  final double progress;

  _SageMapPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw solid grey park blocks to simulate a real map layout
    final parkPaint = Paint()..color = const Color(0xFFDFE4D7);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20, 100, 150, 200), const Radius.circular(16)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(220, 350, 200, 150), const Radius.circular(16)), parkPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-50, 500, 200, 300), const Radius.circular(16)), parkPaint);

    // 2. Draw light sage grid background roads
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 6;
    for (double x = 40; x < size.width; x += 100) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 40; y < size.height; y += 100) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 3. Define the exact path routing down the screen
    final routePath = Path();
    routePath.moveTo(size.width * 0.2, size.height * 0.80); // Start bottom
    routePath.quadraticBezierTo(size.width * 0.1, size.height * 0.55, size.width * 0.5, size.height * 0.60);
    routePath.quadraticBezierTo(size.width * 0.9, size.height * 0.65, size.width * 0.8, size.height * 0.35);
    routePath.quadraticBezierTo(size.width * 0.7, size.height * 0.1, size.width * 0.4, size.height * 0.15); // End Top

    final pathMetrics = routePath.computeMetrics();
    if (pathMetrics.isEmpty) return;
    
    final metric = pathMetrics.first;
    final maxDist = metric.length;
    final currentDist = maxDist * progress;

    // 4. Draw dashed track base (the upcoming unrun distance)
    final dashPaint = Paint()
      ..color = AppColors.sageTextMuted.withValues(alpha: 0.4)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
      
    double d = 0.0;
    while (d < maxDist) {
      canvas.drawPath(metric.extractPath(d, d + 12), dashPaint);
      d += 24;
    }

    // 5. Draw continuous active track (Run so far)
    final activePaint = Paint()
      ..color = AppColors.sageGreen
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    // Smooth line for completed track
    final activePath = metric.extractPath(0.0, currentDist);
    canvas.drawPath(activePath, activePaint);

    // 6. Draw MULTIPLE FLAGS (Route points and End Destination)
    
    // Start Point Flag
    final startPos = metric.getTangentForOffset(0)?.position;
    if (startPos != null) _drawSmallFlag(canvas, startPos, "START");

    // Intermediate Checkpoint (at 50%)
    final check1Pos = metric.getTangentForOffset(maxDist * 0.50)?.position;
    if (check1Pos != null) _drawSmallFlag(canvas, check1Pos, "MID");

    // End Destination Flag (Big Red Flag)
    final endPos = metric.getTangentForOffset(maxDist)?.position;
    if (endPos != null) _drawBigFlag(canvas, endPos);

    // 7. Draw current runner dot
    final currentPos = metric.getTangentForOffset(currentDist)?.position;
    if (currentPos != null) {
      final glowPaint = Paint()
        ..color = AppColors.sageGreen.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(currentPos, 24, glowPaint);

      final outerPaint = Paint()..color = Colors.white;
      canvas.drawCircle(currentPos, 12, outerPaint);

      final innerPaint = Paint()..color = AppColors.sageGreen;
      canvas.drawCircle(currentPos, 6, innerPaint);
    }
  }

  void _drawSmallFlag(Canvas canvas, Offset pos, String label) {
    // Flag pole
    canvas.drawLine(pos, Offset(pos.dx, pos.dy - 20), Paint()..color = AppColors.sageDark..strokeWidth = 3);
    // Base dot
    canvas.drawCircle(pos, 5, Paint()..color = Colors.white);
    canvas.drawCircle(pos, 3, Paint()..color = AppColors.sageDark);
    
    // Flag banner
    final Paint flagPaint = Paint()..color = AppColors.sageDark;
    final path = Path();
    path.moveTo(pos.dx, pos.dy - 20);
    path.lineTo(pos.dx + 16, pos.dy - 14);
    path.lineTo(pos.dx, pos.dy - 8);
    path.close();
    canvas.drawPath(path, flagPaint);
  }

  void _drawBigFlag(Canvas canvas, Offset pos) {
    final pole = Paint()
      ..color = AppColors.sageFlagRed
      ..strokeWidth = 3;
    canvas.drawLine(pos, Offset(pos.dx, pos.dy - 35), pole);
    
    final bannerRect = Rect.fromLTWH(pos.dx, pos.dy - 35, 24, 18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bannerRect, const Radius.circular(4)),
      Paint()..color = AppColors.sageFlagRed,
    );
    
    final base = Paint()..color = Colors.white;
    canvas.drawCircle(pos, 8, base);
    
    final core = Paint()..color = AppColors.sageFlagRed;
    canvas.drawCircle(pos, 4, core);
  }

  @override
  bool shouldRepaint(covariant _SageMapPainter old) => old.progress != progress;
}
