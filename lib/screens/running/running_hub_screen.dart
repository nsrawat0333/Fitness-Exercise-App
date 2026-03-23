import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'goal_selection_screen.dart';

class RunningHubScreen extends StatelessWidget {
  const RunningHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('OVERVIEW', style: AppTextStyles.sageSubtitle.copyWith(letterSpacing: 1.5, fontSize: 12)),
              const SizedBox(height: 4),
              Text('Weekly Progress', style: AppTextStyles.sageTitle.copyWith(fontSize: 34)),
              const SizedBox(height: 24),

              // ── TOTAL DISTANCE CARD ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.sageDark,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL DISTANCE', style: AppTextStyles.sageSubtitle.copyWith(color: Colors.white54, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('45.3', style: AppTextStyles.sageStatBig),
                        const SizedBox(width: 8),
                        Text('km', style: AppTextStyles.sageStatBig.copyWith(fontSize: 24, color: AppColors.sageGreen)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.trending_up, color: AppColors.sageGreenLight, size: 16),
                        const SizedBox(width: 6),
                        Text('12% above last week', style: AppTextStyles.sageSubtitle.copyWith(color: AppColors.sageGreenLight)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── TIME & RUNS ROW ──
              Row(
                children: [
                  Expanded(child: _buildMetricCard('TIME', '4h 21m', 'Moving activity')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMetricCard('RUNS', '6', 'Completed sessions')),
                ],
              ),
              const SizedBox(height: 24),

              // ── PERFORMANCE CHART ──
              _buildPerformanceChart(),
              const SizedBox(height: 16),

              // ── AVERAGE HEART RATE ──
              _buildHeartRateCard(),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Last Route', style: AppTextStyles.sageTitle.copyWith(fontSize: 24)),
                  Text('5.2 km Run', style: AppTextStyles.sageSubtitle.copyWith(color: AppColors.sageGreen, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),
              
              // ── LAST ROUTE MAP CARD ──
              _buildLastRouteMap(),
              const SizedBox(height: 24),

              // ── READY CTA ──
              _buildNextRunCTA(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sageSubtitle.copyWith(fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.sageTitle.copyWith(fontSize: 26, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTextStyles.sageSubtitle.copyWith(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Performance', style: AppTextStyles.sageTitle.copyWith(fontSize: 20)),
                  Text('18 - 24 Nov', style: AppTextStyles.sageSubtitle),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text('View by: Week', style: AppTextStyles.sageSubtitle.copyWith(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
                    const Icon(Icons.arrow_drop_down, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Mock Bar Chart
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(40, '18'),
                _buildBar(60, '19'),
                _buildBar(20, '20'),
                _buildBar(90, '21', isAccent: true), // Highlighted
                _buildBar(50, '22'),
                _buildBar(70, '23'),
                _buildBar(30, '24'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double height, String label, {bool isAccent = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: height,
          decoration: BoxDecoration(
            color: isAccent ? AppColors.sageGreen : AppColors.sageGreenLight.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 12),
        Text(label, style: AppTextStyles.sageSubtitle.copyWith(fontSize: 11)),
      ],
    );
  }

  Widget _buildHeartRateCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.sageGreenLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.sageGreenLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: AppColors.sageGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Average Heart Rate', style: AppTextStyles.sageTitle.copyWith(fontSize: 16)),
                Text('During runs this week', style: AppTextStyles.sageSubtitle.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('142', style: AppTextStyles.sageTitle.copyWith(fontSize: 28, color: AppColors.sageGreen)),
              Text('BPM', style: AppTextStyles.sageSubtitle.copyWith(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLastRouteMap() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.sageMapBg,
        borderRadius: BorderRadius.circular(32),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: CustomPaint(
          painter: _MiniMapPainter(),
          child: Stack(
            children: [
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer, size: 14, color: AppColors.sageGreen),
                        const SizedBox(width: 4),
                        Text('24:12', style: AppTextStyles.sageSubtitle.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)),
                        const SizedBox(width: 12),
                        const Icon(Icons.speed, size: 14, color: AppColors.sageGreen),
                        const SizedBox(width: 4),
                        Text('4\'39"/km', style: AppTextStyles.sageSubtitle.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)),
                      ],
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

  Widget _buildNextRunCTA(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalSelectionScreen()));
      },
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          // Using a solid dark color simulation if image asset is unavailable
          color: AppColors.sageDark,
        ),
        child: Stack(
          children: [
            // Faux image background pattern
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Image.network('https://images.unsplash.com/photo-1552674605-db6ffd4facb5?q=80&w=600', fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ready for\nyour\nnext run?',
                      style: AppTextStyles.sageTitle.copyWith(color: Colors.white, fontSize: 28, height: 1.1),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.sageGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'START\nNOW',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sageTitle.copyWith(color: Colors.white, fontSize: 14, height: 1.2),
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

// ── CUSTOM PAINTER FOR MINI MAP (DOTTED LINE + RED FLAG) ──
class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid dots
    final dotPaint = Paint()..color = AppColors.sageGreenLight.withValues(alpha: 0.5);
    for (double x = 20; x < size.width; x += 30) {
      for (double y = 20; y < size.height; y += 30) {
        canvas.drawCircle(Offset(x, y), 1.5, dotPaint);
      }
    }

    // Define sine wave route path
    final path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.3, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.7, size.width * 0.85, size.height * 0.3);

    // Draw dotted path
    final pathMetrics = path.computeMetrics().first;
    final pathPaint = Paint()
      ..color = AppColors.sageGreen
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    double distance = 0.0;
    while (distance < pathMetrics.length) {
      final extractPath = pathMetrics.extractPath(distance, distance + 6);
      canvas.drawPath(extractPath, pathPaint);
      distance += 14;
    }

    // Start point Ring
    final startPos = pathMetrics.getTangentForOffset(0)?.position ?? Offset.zero;
    canvas.drawCircle(startPos, 6, Paint()..color = Colors.white);
    canvas.drawCircle(startPos, 3, Paint()..color = AppColors.sageGreen);

    // End point Flag
    final endPos = pathMetrics.getTangentForOffset(pathMetrics.length)?.position ?? Offset.zero;
    
    // Draw flag pole
    canvas.drawLine(endPos, Offset(endPos.dx, endPos.dy - 30), Paint()..color = AppColors.sageFlagRed..strokeWidth = 2);
    // Draw flag banner
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(endPos.dx, endPos.dy - 30, 20, 14), const Radius.circular(2)),
      Paint()..color = AppColors.sageFlagRed,
    );
    // Flag pole base
    canvas.drawCircle(endPos, 3, Paint()..color = AppColors.sageFlagRed);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
