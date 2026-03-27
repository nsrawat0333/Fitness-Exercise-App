import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../data/gym_user_data.dart';
import 'gym_plan_generation_screen.dart';

/// Gym Onboarding Step 5 – "Let us know you better" (Height + Weight)
class GymBodyInfoScreen extends StatefulWidget {
  const GymBodyInfoScreen({super.key});

  @override
  State<GymBodyInfoScreen> createState() => _GymBodyInfoScreenState();
}

class _GymBodyInfoScreenState extends State<GymBodyInfoScreen> {
  // Height
  bool _heightIsCm = true;
  late FixedExtentScrollController _heightController;
  int _heightCm = 180;

  // Weight
  bool _weightIsKg = true;
  double _weightKg = 74.5;

  @override
  void initState() {
    super.initState();
    // Start the wheel at 180 cm (index = 180 - 100 = 80)
    _heightController = FixedExtentScrollController(initialItem: _heightCm - 100);
  }

  @override
  void dispose() {
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    'Step 5 of 5',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GymPlanGenerationScreen())),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Progress Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0DCD4),
                  borderRadius: BorderRadius.circular(3),
                ),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      Center(
                        child: Text(
                          'Let us know you better',
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Height Card ──
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE8E4DD)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Height', style: GoogleFonts.outfit(
                                  fontSize: 18, fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                )),
                                _buildToggle(
                                  leftLabel: 'cm',
                                  rightLabel: 'ft',
                                  isLeftActive: _heightIsCm,
                                  onTap: () => setState(() => _heightIsCm = !_heightIsCm),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Scroll wheel picker
                            SizedBox(
                              height: 150,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Center highlight bar
                                  Container(
                                    height: 44,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: const Color(0xFFE0DCD4), width: 1),
                                        bottom: BorderSide(color: const Color(0xFFE0DCD4), width: 1),
                                      ),
                                    ),
                                  ),
                                  // Indicator line
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      width: 30,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                  // Wheel
                                  ListWheelScrollView.useDelegate(
                                    controller: _heightController,
                                    itemExtent: 44,
                                    perspective: 0.003,
                                    diameterRatio: 1.5,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (i) {
                                      setState(() => _heightCm = i + 100);
                                    },
                                    childDelegate: ListWheelChildBuilderDelegate(
                                      childCount: 121, // 100 to 220
                                      builder: (context, index) {
                                        final val = index + 100;
                                        final isCenter = val == _heightCm;
                                        return Center(
                                          child: Text(
                                            '$val',
                                            style: GoogleFonts.outfit(
                                              fontSize: isCenter ? 36 : 18,
                                              fontWeight: isCenter ? FontWeight.w800 : FontWeight.w400,
                                              color: isCenter
                                                  ? AppColors.textPrimary
                                                  : AppColors.textSecondary.withValues(alpha: 0.5),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),
                            // Display value
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: _heightIsCm
                                          ? '$_heightCm'
                                          : (_heightCm / 30.48).toStringAsFixed(1),
                                      style: GoogleFonts.outfit(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _heightIsCm ? ' cm' : ' ft',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Weight Card ──
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE8E4DD)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Weight', style: GoogleFonts.outfit(
                                  fontSize: 18, fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                )),
                                _buildToggle(
                                  leftLabel: 'kg',
                                  rightLabel: 'lbs',
                                  isLeftActive: _weightIsKg,
                                  onTap: () => setState(() => _weightIsKg = !_weightIsKg),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Weight display
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: _weightIsKg
                                          ? _weightKg.toStringAsFixed(1)
                                          : (_weightKg * 2.205).toStringAsFixed(1),
                                      style: GoogleFonts.outfit(
                                        fontSize: 42,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _weightIsKg ? ' kg' : ' lbs',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Vertical bar slider
                            SizedBox(
                              height: 80,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return GestureDetector(
                                    onHorizontalDragUpdate: (details) {
                                      final dx = details.localPosition.dx;
                                      final fraction = (dx / constraints.maxWidth).clamp(0.0, 1.0);
                                      setState(() {
                                        _weightKg = 30 + (fraction * 170); // 30-200 kg range
                                      });
                                    },
                                    child: CustomPaint(
                                      size: Size(constraints.maxWidth, 80),
                                      painter: _WeightBarPainter(
                                        value: _weightKg,
                                        minVal: 30,
                                        maxVal: 200,
                                        primaryColor: AppColors.primary,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: GestureDetector(
                onTap: () {
                  GymUserData().heightCm = _heightCm.toDouble();
                  GymUserData().weightKg = _weightKg;
                  GymUserData().isHeightCm = _heightIsCm;
                  GymUserData().isWeightKg = _weightIsKg;
                  
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => GymPlanGenerationScreen(
                      heightCm: _heightCm.toDouble(),
                      weightKg: _weightKg,
                      heightIsCm: _heightIsCm,
                      weightIsKg: _weightIsKg,
                    )));
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('GET MY PLAN', style: GoogleFonts.outfit(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        letterSpacing: 1.0, color: Colors.white,
                      )),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle({
    required String leftLabel,
    required String rightLabel,
    required bool isLeftActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E4DD),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isLeftActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                leftLabel,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isLeftActive ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: !isLeftActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                rightLabel,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: !isLeftActive ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for weight bar slider
class _WeightBarPainter extends CustomPainter {
  final double value;
  final double minVal;
  final double maxVal;
  final Color primaryColor;

  _WeightBarPainter({
    required this.value,
    required this.minVal,
    required this.maxVal,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 4.0;
    final spacing = 20.0;
    final totalBars = (size.width / spacing).floor();
    final fraction = ((value - minVal) / (maxVal - minVal)).clamp(0.0, 1.0);
    final activeIndex = (fraction * totalBars).round();

    for (int i = 0; i < totalBars; i++) {
      final x = i * spacing + spacing / 2;
      final isActive = i == activeIndex;
      final isNearby = (i - activeIndex).abs() <= 1;
      final barHeight = isActive ? 60.0 : (isNearby ? 40.0 : 28.0);
      final y = (size.height - barHeight) / 2;

      final paint = Paint()
        ..color = isActive
            ? primaryColor
            : (isNearby ? primaryColor.withValues(alpha: 0.3) : const Color(0xFFE0DCD4))
        ..strokeCap = StrokeCap.round;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - barWidth / 2, y, barWidth, barHeight),
          const Radius.circular(2),
        ),
        paint,
      );

      // Label under every 5th bar
      if (i % 5 == 0) {
        final labelVal = (minVal + (i / totalBars) * (maxVal - minVal)).round();
        final textPainter = TextPainter(
          text: TextSpan(
            text: '$labelVal',
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFF999691),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height - 12));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WeightBarPainter old) => old.value != value;
}
