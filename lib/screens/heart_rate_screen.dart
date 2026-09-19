import 'dart:math';

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/heart_rate_service.dart';
import '../services/health_storage_service.dart';

enum ScanState { initial, scanning, result }

/// Screen showcasing the Heart Rate Monitor / BPM Scan flow.
/// It cycles exactly through Initial -> Scanning -> Result.
class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen>
    with TickerProviderStateMixin {
  ScanState _currentState = ScanState.initial;

  // ── Animation Controllers ──
  late AnimationController _pulseCtrl;
  late AnimationController _progressCtrl;
  late AnimationController _equalizerCtrl;

  // ── Heart Rate Service ──
  final _hrService = HeartRateService();
  int _finalBpm = 0;

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Give it 10 seconds to find a good pulse, then jump to Result
    _progressCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 10));
    _progressCtrl.addStatusListener(_onScanProgressStatusChanged);

    _equalizerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressCtrl.removeStatusListener(_onScanProgressStatusChanged);
    _hrService.stopMeasurement();
    _pulseCtrl.dispose();
    _progressCtrl.dispose();
    _equalizerCtrl.dispose();
    super.dispose();
  }

  void _onScanProgressStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && _currentState == ScanState.scanning) {
      _completeScan();
    }
  }

  Future<void> _completeScan() async {
    if (!mounted || _currentState != ScanState.scanning) return;

    _finalBpm = _hrService.readingNotifier.value.bpm;
    if (_finalBpm == 0) {
      _finalBpm = HealthStorageService().healthDataNotifier.value.lastBpm;
    }
    if (_finalBpm == 0) {
      _finalBpm = 72; // Final fallback if no prior reading exists.
    }

    await HealthStorageService().updateBpm(_finalBpm);
    await _hrService.stopMeasurement();

    if (mounted) {
      setState(() => _currentState = ScanState.result);
    }
  }

  void _startScan() async {
    setState(() => _currentState = ScanState.scanning);
    _progressCtrl.forward(from: 0);
    
    await _hrService.startMeasurement();
  }

  void _resetScan() {
    _progressCtrl.stop();
    _hrService.stopMeasurement();
    setState(() {
      _currentState = ScanState.initial;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic background based on state
    final bgColor = _currentState == ScanState.scanning
        ? AppColors.hrScanBg
        : _currentState == ScanState.result
            ? AppColors.hrResultBg
            : AppColors.hrScreenBg;

    return Scaffold(
      backgroundColor: bgColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          color: bgColor,
          gradient: _currentState == ScanState.result
              ? const LinearGradient(
                  colors: [Color(0xFFFFF0F3), Color(0xFFFEF3F5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: _buildCurrentState(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentState() {
    switch (_currentState) {
      case ScanState.initial:
        return _buildInitialState(key: const ValueKey('initial'));
      case ScanState.scanning:
        return _buildScanningState(key: const ValueKey('scanning'));
      case ScanState.result:
        return _buildResultState(key: const ValueKey('result'));
    }
  }

  // ══════════════════════════════════════════════════════════════
  // STATE 1: INITIAL UI
  // ══════════════════════════════════════════════════════════════
  Widget _buildInitialState({required Key key}) {
    return Column(
      key: key,
      children: [
        // App Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              ),
              const Expanded(
                child: Center(
                  child: Text('Heart Rate Monitor',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                ),
              ),
              const SizedBox(width: 24), // balance back arrow
            ],
          ),
        ),
        const Spacer(),

        // Fingerprint Circle
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.hrFingerprintIcon.withValues(alpha: 0.05),
                      blurRadius: 40,
                      spreadRadius: 20),
                ],
              ),
            ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.hrFingerprintIcon.withValues(alpha: 0.05),
                    width: 2),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fingerprint,
                    size: 80, color: AppColors.hrFingerprintIcon),
                const SizedBox(height: 16),
                Icon(Icons.favorite,
                    size: 20,
                    color: AppColors.hrFingerprintIcon.withValues(alpha: 0.3)),
              ],
            ),
          ],
        ),

        const SizedBox(height: 60),

        // Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Place your finger on the flashlight to start scanning',
            textAlign: TextAlign.center,
            style: AppTextStyles.hrInstruction,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDot(true),
            _buildDot(false),
            _buildDot(false),
          ],
        ),

        const Spacer(),

        // Action Button
        GestureDetector(
          onTap: _startScan,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.hrGreenBtn,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Start Scan',
                    style: AppTextStyles.heading3
                        .copyWith(color: Colors.white)),
                const SizedBox(width: 12),
                const Icon(Icons.play_arrow, color: Colors.white),
              ],
            ),
          ),
        ),

        const SizedBox(height: 40),

        ValueListenableBuilder<HealthData>(
          valueListenable: HealthStorageService().healthDataNotifier,
          builder: (context, healthData, _) {
            final lastReadingLabel = healthData.lastBpm > 0 ? '${healthData.lastBpm} ' : '-- ';
            final avgReadingLabel = healthData.dailyAvgBpm > 0 ? '${healthData.dailyAvgBpm} ' : '-- ';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LAST READING', style: AppTextStyles.cardLabel),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(text: lastReadingLabel, style: AppTextStyles.heading2),
                              TextSpan(text: 'BPM', style: AppTextStyles.bodyMedium),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DAILY AVG', style: AppTextStyles.cardLabel),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(text: avgReadingLabel, style: AppTextStyles.heading2),
                              TextSpan(text: 'BPM', style: AppTextStyles.bodyMedium),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildDot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? AppColors.hrGreenBtn
            : AppColors.hrGreenBtn.withValues(alpha: 0.3),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // STATE 2: SCANNING UI
  // ══════════════════════════════════════════════════════════════
  Widget _buildScanningState({required Key key}) {
    return Column(
      key: key,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: _resetScan,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text('BIOMETRICS',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                          color: Colors.white70)),
                ),
              ),
              const SizedBox(width: 36),
            ],
          ),
        ),

        const Spacer(flex: 2),

        // Glowing Pulse Indicator
        AnimatedBuilder(
          animation: Listenable.merge([_pulseCtrl, _progressCtrl]),
          builder: (context, child) {
            return Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: _ScanningPulsePainter(
                    pulseValue: _pulseCtrl.value,
                    progressValue: _progressCtrl.value,
                  ),
                  child: Center(
                    child: Transform.scale(
                      scale: 1.0 + 0.1 * _pulseCtrl.value,
                      child: const Icon(Icons.favorite,
                          size: 60, color: AppColors.hrPulseRed),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const Spacer(flex: 2),

        ValueListenableBuilder<HeartRateReading>(
          valueListenable: _hrService.readingNotifier,
          builder: (context, reading, _) {
            if (reading.bpm > 0) {
              return Column(
                children: [
                  Text('${reading.bpm}', style: AppTextStyles.hrBpmHuge),
                  Text('BPM', style: AppTextStyles.hrBpmUnit),
                  const SizedBox(height: 8),
                  Text('Signal Quality: ${(reading.signalQuality * 100).toInt()}%', 
                       style: AppTextStyles.bodySmall.copyWith(color: AppColors.heartPink)),
                ],
              );
            }
            return Column(
              children: [
                Text('Scanning . . .', style: AppTextStyles.hrScanTitle),
                const SizedBox(height: 8),
                Text('Analyzing your heart rate', style: AppTextStyles.hrScanSub),
              ],
            );
          },
        ),

        const SizedBox(height: 40),

        // Pill button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.fingerprint,
                  color: AppColors.hrPulseRed.withValues(alpha: 0.8), size: 20),
              const SizedBox(width: 12),
              const Text('Keep your finger steady',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Audio Equalizer Anim
        SizedBox(
          height: 60,
          child: AnimatedBuilder(
            animation: _equalizerCtrl,
            builder: (context, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(11, (index) {
                  // A slightly chaotic pseudo-random bounce height
                  final sinVal = sin((_equalizerCtrl.value * pi * 2) + index);
                  final height = 15 + (sinVal.abs() * 45);
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 4,
                    height: height,
                    decoration: BoxDecoration(
                      color: AppColors.hrPulseRedDark
                          .withValues(alpha: 0.4 + (sinVal.abs() * 0.4)),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  // STATE 3: RESULT UI
  // ══════════════════════════════════════════════════════════════
  Widget _buildResultState({required Key key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App Bar
          Row(
            children: [
              GestureDetector(
                onTap: _resetScan,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back,
                      color: AppColors.hrPinkBtn, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              const Text('Health Stats',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.share,
                    color: AppColors.textPrimary, size: 20),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Pink top heart circle
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.heartPink.withValues(alpha: 0.4),
                  AppColors.hrResultBg.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: const Center(
              child: Icon(Icons.favorite, color: AppColors.hrPinkBtn, size: 36),
            ),
          ),
          const SizedBox(height: 8),

          Text('AVERAGE PULSE RATE',
              style: AppTextStyles.cardLabel
                  .copyWith(color: AppColors.heartPink)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$_finalBpm', style: AppTextStyles.hrBpmHuge),
              const SizedBox(width: 8),
              Text('BPM', style: AppTextStyles.hrBpmUnit),
            ],
          ),
          const SizedBox(height: 16),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                    color: AppColors.hrPinkBtn.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: AppColors.hrPinkBtn, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text('Normal',
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.hrPinkBtn,
                        fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Text('|',
                    style: TextStyle(color: AppColors.textMuted)),
                const SizedBox(width: 8),
                Text('Vital signs are excellent',
                    style: AppTextStyles.bodySmall),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Grid (Stress and Recovery)
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 160,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.hrPinkBtn.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: CustomPaint(
                          painter: _StressRingPainter(percent: 0.35),
                          child: Center(
                            child: Text('35%',
                                style: AppTextStyles.heading2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('STRESS LEVEL', style: AppTextStyles.cardLabel),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 160,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.hrPinkBtn.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.heartPink.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.bolt,
                            color: AppColors.hrPulseRed, size: 30),
                      ),
                      const SizedBox(height: 12),
                      Text('92%', style: AppTextStyles.hrStatValue),
                      const SizedBox(height: 4),
                      Text('RECOVERY', style: AppTextStyles.cardLabel),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Restorative Pulse Description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: AppColors.hrPinkBtn.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.hrPinkBtn,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Restorative Pulse', style: AppTextStyles.heading3),
                      const SizedBox(height: 8),
                      Text(
                        'Your heart rhythm is exceptionally resilient today. This level of consistency indicates your body is handling physical and mental stressors with ease. Perfect for high-focus tasks.',
                        style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Weekly Trend Chart
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: AppColors.hrPinkBtn.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weekly Trend', style: AppTextStyles.heading3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.stepGreenLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.trending_down,
                              color: AppColors.primaryLight, size: 12),
                          const SizedBox(width: 4),
                          Text('-4% VS LAST WEEK',
                              style: AppTextStyles.cardLabel.copyWith(
                                  color: AppColors.primaryLight, fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Pseudo Bar Chart
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar('MON', 0.4, false),
                      _buildBar('TUE', 0.45, false),
                      _buildBar('WED', 0.7, false),
                      _buildBar('THU', 0.35, false),
                      _buildBar('FRI', 0.4, false),
                      _buildBar('SAT', 0.9, true),
                      _buildBar('SUN', 0.4, false),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          GestureDetector(
            onTap: _resetScan,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.hrPinkBtn,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                   BoxShadow(
                      color: AppColors.hrPinkBtn.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.compare_arrows, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Measure Again',
                      style: AppTextStyles.heading3
                          .copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.hrPinkBtn.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('View Full History',
                    style: AppTextStyles.heading3
                        .copyWith(color: AppColors.hrPinkBtn)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward,
                    color: AppColors.hrPinkBtn, size: 18),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double heightFraction, bool isToday) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 22,
          height: 80 * heightFraction,
          decoration: BoxDecoration(
            color: isToday
                ? AppColors.hrPinkBtn
                : AppColors.heartPink.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          day,
          style: AppTextStyles.cardLabel.copyWith(
            color: isToday ? AppColors.hrPinkBtn : AppColors.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ══════════════════════════════════════════════════════════════

/// Painter for the Scanning animation (rings and progress).
class _ScanningPulsePainter extends CustomPainter {
  final double pulseValue;
  final double progressValue;

  _ScanningPulsePainter(
      {required this.pulseValue, required this.progressValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2 - 20; // leaves room for outer track

    // Draw inner pulsing glowing rings
    final rings = 3;
    for (int i = 0; i < rings; i++) {
      final ringProgress = (pulseValue + (i / rings)) % 1.0;
      final ringRadius = baseRadius * ringProgress;

      // Dark red gradient glow
      final paint = Paint()
        ..color =
            AppColors.hrPulseRedDark.withValues(alpha: (1.0 - ringProgress) * 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, ringRadius, paint);

      // Light outline
      final linePaint = Paint()
        ..color =
            AppColors.hrPulseRedDark.withValues(alpha: (1.0 - ringProgress) * 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(center, ringRadius, linePaint);
    }

    // Outer track
    final trackRadius = size.width / 2 - 6;
    final trackPaint = Paint()
      ..color = AppColors.hrPulseRedDark.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;
    canvas.drawCircle(center, trackRadius, trackPaint);

    // Measuring progress arc
    final progressPaint = Paint()
      ..color = AppColors.hrPulseRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progressValue;
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: trackRadius),
        -pi / 2, // start top
        sweepAngle,
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(covariant _ScanningPulsePainter old) =>
      old.pulseValue != pulseValue || old.progressValue != progressValue;
}

/// Painter for the 35% Stress Ring
class _StressRingPainter extends CustomPainter {
  final double percent;
  _StressRingPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final trackPaint = Paint()
      ..color = AppColors.heartPink.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = AppColors.hrPinkBtn
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * pi * percent;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        sweep, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _StressRingPainter old) => old.percent != percent;
}
