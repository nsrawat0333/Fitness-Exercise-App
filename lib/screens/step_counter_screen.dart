import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../utils/app_utils.dart';

import '../services/step_counter_service.dart';

/// Step Counter Screen – exact replica of the Stitch design.
class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _progressAnim;
  bool _syncVisible = true;
  int _avgTabIndex = 0; // 0 = Weekly, 1 = Monthly

  final StepCounterService _stepService = StepCounterService();

  int get _goal => StepCounterService.dailyGoal;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _progressAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ─── Build ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stepScreenBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildAppBar(context),
              const SizedBox(height: 24),
              _buildCircularProgress(),
              const SizedBox(height: 16),
              _buildMotivationBanner(),
              const SizedBox(height: 20),
              _buildDailyAverageCard(),
              const SizedBox(height: 16),
              if (_syncVisible) _buildSyncBanner(),
              if (_syncVisible) const SizedBox(height: 20),
              _buildMonthlyGoal(),
              const SizedBox(height: 28),
              _buildStepTrends(),
              const SizedBox(height: 28),
              _buildRecentHistory(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── 1. App Bar ─────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Text('Step Counter', style: AppTextStyles.heading3),
        const Spacer(),
        Text('READY, USER', style: AppTextStyles.greeting),
        const SizedBox(width: 10),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.stepGreen, width: 2),
            color: AppColors.stepGreenLight,
          ),
          child: const Icon(Icons.person, size: 18, color: AppColors.primary),
        ),
      ],
    );
  }

  // ── 2. Circular Progress ───────────────────────────────
  Widget _buildCircularProgress() {
    return ValueListenableBuilder<StepData>(
      valueListenable: _stepService.stepDataNotifier,
      builder: (context, stepData, _) {
        return AnimatedBuilder(
          animation: _progressAnim,
          builder: (context, _) {
            final double animatedProgress = (stepData.steps / _goal) * _progressAnim.value;
            final int animatedSteps = (stepData.steps * _progressAnim.value).round();
            return Center(
              child: Column(
                children: [
                  Text('STEPS TODAY',
                      style: AppTextStyles.cardLabel.copyWith(letterSpacing: 2, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CustomPaint(
                      painter: _StepArcPainter(progress: animatedProgress),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(AppUtils.formatNumber(animatedSteps),
                                style: AppTextStyles.stepScreenCount),
                            const SizedBox(height: 4),
                            Text('Goal: ${AppUtils.formatNumber(_goal)}',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── 3. Motivation Banner ───────────────────────────────
  Widget _buildMotivationBanner() {
    return ValueListenableBuilder<StepData>(
      valueListenable: _stepService.stepDataNotifier,
      builder: (context, stepData, _) {
        final remaining = (_goal - stepData.steps).clamp(0, _goal);
        final isGoalReached = stepData.steps >= _goal;
        final message = isGoalReached
            ? 'Goal reached today. Excellent consistency!'
            : remaining == _goal
                ? 'Let\'s start fresh today. Every step counts.'
                : '$remaining steps left to hit today\'s goal.';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.stepGreen.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.stepGreenLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(Icons.directions_walk, color: AppColors.primary, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── 4. Daily Average Card ──────────────────────────────
  Widget _buildDailyAverageCard() {
    return ValueListenableBuilder<StepStats>(
      valueListenable: _stepService.stepStatsNotifier,
      builder: (context, stats, _) {
        final averageValue = _avgTabIndex == 0 ? stats.weeklyAverage : stats.monthlyAverage;
        final trendText = _formatTrend(stats.weeklyTrendPercent);
        final trendUp = stats.weeklyTrendPercent >= 0;
        final bars = _buildWeeklyBars(stats.weeklySteps);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DAILY AVERAGE', style: AppTextStyles.cardLabel),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppUtils.formatNumber(averageValue),
                          style: AppTextStyles.stepScreenStatValue,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              trendUp ? Icons.trending_up : Icons.trending_down,
                              size: 16,
                              color: trendUp ? AppColors.stepGreen : Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trendText,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: trendUp ? AppColors.stepGreen : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 600 + i * 80),
                          curve: Curves.easeOutCubic,
                          width: 8,
                          height: 40 * bars[i],
                          decoration: BoxDecoration(
                            color: i == 6
                                ? AppColors.stepGreen
                                : AppColors.stepGreen.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _tabButton('WEEKLY', 0),
                  const SizedBox(width: 12),
                  _tabButton('MONTHLY', 1),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tabButton(String label, int index) {
    final bool active = _avgTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _avgTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.stepGreenLight : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.stepGreen : AppColors.textMuted.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.cardLabel.copyWith(
            color: active ? AppColors.primary : AppColors.textSecondary,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── 5. Sync Banner ─────────────────────────────────────
  Widget _buildSyncBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.syncBannerBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.stepGreen, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text('Steps synced with FitFi Health',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
          ),
          GestureDetector(
            onTap: () => setState(() => _syncVisible = false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.stepGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text('CLOSE',
                  style: AppTextStyles.cardLabel.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
          ),
        ],
      ),
    );
  }

  // ── 6. Monthly Goal ────────────────────────────────────
  Widget _buildMonthlyGoal() {
    return ValueListenableBuilder<StepStats>(
      valueListenable: _stepService.stepStatsNotifier,
      builder: (context, stats, _) {
        final progress =
            stats.monthlyTarget == 0 ? 0.0 : (stats.monthlyCurrent / stats.monthlyTarget).clamp(0.0, 1.0);
        final percent = (progress * 100).round();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Goal',
                        style: AppTextStyles.stepScreenSectionTitle.copyWith(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 4),
                      Text('Real-time progress from your tracked steps', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${AppUtils.formatNumber(stats.monthlyCurrent)} / ${AppUtils.formatNumber(stats.monthlyTarget)} steps',
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '$percent%',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.stepGreen),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.stepGreenLight,
                valueColor: const AlwaysStoppedAnimation(AppColors.stepGreen),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── 7. Step Trends ─────────────────────────────────────
  Widget _buildStepTrends() {
    return ValueListenableBuilder<StepStats>(
      valueListenable: _stepService.stepStatsNotifier,
      builder: (context, stats, _) {
        final bars = _buildWeeklyBars(stats.weeklySteps);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step Trends', style: AppTextStyles.stepScreenSectionTitle),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 160,
                    child: CustomPaint(
                      size: const Size(double.infinity, 160),
                      painter: _TrendChartPainter(bars: bars),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: stats.weeklyLabels
                        .map(
                          (d) => Text(
                            d,
                            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ── 8. Recent History ──────────────────────────────────
  Widget _buildRecentHistory() {
    return ValueListenableBuilder<StepStats>(
      valueListenable: _stepService.stepStatsNotifier,
      builder: (context, stats, _) {
        final entries = stats.history;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Recent History', style: AppTextStyles.stepScreenSectionTitle),
                const Spacer(),
                Text(
                  '${entries.length} days',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.stepGreen, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...entries.map((item) {
              final label = item.goalReached
                  ? 'GOAL REACHED'
                  : item.steps == 0
                      ? 'STARTED'
                      : 'ACTIVE';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.stepGreenLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.goalReached ? Icons.emoji_events_outlined : Icons.directions_walk,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatHistoryDate(item.date),
                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              label,
                              style: AppTextStyles.bodySmall.copyWith(fontSize: 10, letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppUtils.formatNumber(item.steps),
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text(
                            item.goalReached ? 'MET' : (item.steps == 0 ? 'START' : 'ACTIVE'),
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10,
                              letterSpacing: 1,
                              color: AppColors.stepGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  List<double> _buildWeeklyBars(List<int> weeklySteps) {
    if (weeklySteps.isEmpty) return const [0, 0, 0, 0, 0, 0, 0];
    final maxStep = weeklySteps.reduce(max);
    final baseline = max(maxStep, _goal);
    if (baseline == 0) return List<double>.filled(weeklySteps.length, 0);
    return weeklySteps.map((value) => (value / baseline).clamp(0.0, 1.0)).toList();
  }

  String _formatTrend(double trendPercent) {
    if (trendPercent == 0) return 'No change from last week';
    final absValue = trendPercent.abs();
    final formatted = absValue >= 10 ? absValue.toStringAsFixed(0) : absValue.toStringAsFixed(1);
    final sign = trendPercent > 0 ? '+' : '-';
    return '$sign$formatted% from last week';
  }

  String _formatHistoryDate(DateTime date) {
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// ═══════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ═══════════════════════════════════════════════════════════

/// Arc painter for the circular step progress ring.
class _StepArcPainter extends CustomPainter {
  final double progress; // 0.0 – 1.0

  _StepArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;
    const strokeWidth = 14.0;
    const startAngle = 2.3; // ~132°
    const sweepFull = 2 * pi - (2 * (startAngle - pi));

    // Track
    final trackPaint = Paint()
      ..color = AppColors.stepTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius), startAngle, sweepFull, false, trackPaint);

    // Progress arc with gradient
    if (progress > 0) {
      final sweepAngle = sweepFull * progress.clamp(0.0, 1.0);
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: const [AppColors.stepRing, AppColors.primaryLight],
      );
      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StepArcPainter old) => old.progress != progress;
}

/// Bar + line chart painter for Step Trends section.
class _TrendChartPainter extends CustomPainter {
  final List<double> bars;

  _TrendChartPainter({required this.bars});

  @override
  void paint(Canvas canvas, Size size) {
    final int count = bars.length;
    final double barWidth = 16;
    final double maxBarH = size.height - 20;

    // Y-axis labels
    final labelPaint = TextPainter(textDirection: TextDirection.ltr);
    for (var val in ['12K', '8K', '4K']) {
      labelPaint.text = TextSpan(
        text: val,
        style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
      );
      labelPaint.layout();
      double y;
      if (val == '12K') {
        y = 0;
      } else if (val == '8K') {
        y = maxBarH * 0.33;
      } else {
        y = maxBarH * 0.66;
      }
      labelPaint.paint(canvas, Offset(0, y));
    }

    final double chartLeft = 30;
    final double chartWidth = size.width - chartLeft;
    final double s = (chartWidth - count * barWidth) / (count + 1);

    // Grid lines
    final gridPaint = Paint()
      ..color = AppColors.textMuted.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    for (double frac in [0.0, 0.33, 0.66, 1.0]) {
      double y = maxBarH * frac;
      canvas.drawLine(Offset(chartLeft, y), Offset(size.width, y), gridPaint);
    }

    // Bars
    final List<Offset> linePoints = [];
    for (int i = 0; i < count; i++) {
      final double x = chartLeft + s * (i + 1) + barWidth * i;
      final double h = maxBarH * bars[i];
      final double y = maxBarH - h;

      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, h),
        const Radius.circular(4),
      );
      final isHighlight = i == 4; // Thursday
      canvas.drawRRect(
        barRect,
        Paint()..color = isHighlight ? AppColors.stepGreen : AppColors.stepGreen.withValues(alpha: 0.18),
      );
      linePoints.add(Offset(x + barWidth / 2, y + 6));
    }

    // Trend line
    if (linePoints.length > 1) {
      final linePaint = Paint()
        ..color = AppColors.textSecondary.withValues(alpha: 0.4)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      final path = Path()..moveTo(linePoints.first.dx, linePoints.first.dy);
      for (int i = 1; i < linePoints.length; i++) {
        final prev = linePoints[i - 1];
        final curr = linePoints[i];
        final cpx = (prev.dx + curr.dx) / 2;
        path.cubicTo(cpx, prev.dy, cpx, curr.dy, curr.dx, curr.dy);
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter old) => false;
}

