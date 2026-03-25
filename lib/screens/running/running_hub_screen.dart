import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/run_data.dart';
import '../../services/run_storage_service.dart';
import 'goal_selection_screen.dart';

/// Dashboard – weekly stats, run history, and start-run CTA.
class RunningHubScreen extends StatefulWidget {
  const RunningHubScreen({super.key});

  @override
  State<RunningHubScreen> createState() => _RunningHubScreenState();
}

class _RunningHubScreenState extends State<RunningHubScreen> with SingleTickerProviderStateMixin {
  double _totalDistKm = 0;
  int _totalTimeSec = 0;
  int _runsCount = 0;
  int _totalSteps = 0;
  int _improvement = 0;
  List<RunRecord> _history = [];
  bool _loading = true;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await RunStorageService.getWeeklyStats();
    final history = await RunStorageService.loadHistory();
    if (!mounted) return;
    setState(() {
      _totalDistKm = stats['totalDistKm'];
      _totalTimeSec = stats['totalTimeSec'];
      _runsCount = stats['runsCount'];
      _totalSteps = stats['totalSteps'];
      _improvement = stats['improvement'];
      _history = history;
      _loading = false;
    });
    _animCtrl.forward();
  }

  String _formatTime(int secs) {
    final h = secs ~/ 3600;
    final m = (secs % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sageBg,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.sageGreen))
            : FadeTransition(
                opacity: _fadeAnim,
                child: RefreshIndicator(
                  color: AppColors.sageGreen,
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── HEADER ──
                        Text('OVERVIEW',
                            style: AppTextStyles.sageSubtitle
                                .copyWith(letterSpacing: 1.5, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('Weekly Progress',
                            style: AppTextStyles.sageTitle.copyWith(fontSize: 34)),
                        const SizedBox(height: 24),

                        // ── TOTAL DISTANCE HERO CARD ──
                        _buildHeroCard(),
                        const SizedBox(height: 16),

                        // ── TIME / RUNS / STEPS ROW ──
                        Row(
                          children: [
                            Expanded(child: _buildMetricCard('TIME', _formatTime(_totalTimeSec), 'Moving activity')),
                            const SizedBox(width: 12),
                            Expanded(child: _buildMetricCard('RUNS', '$_runsCount', 'This week')),
                            const SizedBox(width: 12),
                            Expanded(child: _buildMetricCard('STEPS', _formatSteps(_totalSteps), 'Total')),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // ── PERFORMANCE CHART ──
                        _buildPerformanceChart(),
                        const SizedBox(height: 28),

                        // ── RUN HISTORY ──
                        if (_history.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Run History',
                                  style: AppTextStyles.sageTitle.copyWith(fontSize: 22)),
                              Text('${_history.length} runs',
                                  style: AppTextStyles.sageSubtitle
                                      .copyWith(color: AppColors.sageGreen, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ..._history.take(5).map(_buildHistoryTile),
                          const SizedBox(height: 24),
                        ],

                        // ── START RUN CTA ──
                        _buildNextRunCTA(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  String _formatSteps(int steps) {
    if (steps >= 1000) return '${(steps / 1000).toStringAsFixed(1)}k';
    return '$steps';
  }

  // ── HERO CARD ──
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.sageDark,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TOTAL DISTANCE',
              style: AppTextStyles.sageSubtitle
                  .copyWith(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(_totalDistKm.toStringAsFixed(1),
                  style: AppTextStyles.sageStatBig),
              const SizedBox(width: 8),
              Text('km',
                  style: AppTextStyles.sageStatBig
                      .copyWith(fontSize: 24, color: AppColors.sageGreen)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                _improvement >= 0 ? Icons.trending_up : Icons.trending_down,
                color: AppColors.sageGreenLight,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                _improvement >= 0
                    ? '$_improvement% above last week'
                    : '${_improvement.abs()}% below last week',
                style: AppTextStyles.sageSubtitle
                    .copyWith(color: AppColors.sageGreenLight),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── METRIC CARD ──
  Widget _buildMetricCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.sageSubtitle.copyWith(fontSize: 10, letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Text(value,
              style: AppTextStyles.sageTitle
                  .copyWith(fontSize: 22, letterSpacing: -0.5)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: AppTextStyles.sageSubtitle.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  // ── BAR CHART ──
  Widget _buildPerformanceChart() {
    // Get last 7 days run distances
    final now = DateTime.now();
    final dayLabels = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d.weekday - 1];
    });
    final dayDistances = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return _history
          .where((r) =>
              r.startTime.year == d.year &&
              r.startTime.month == d.month &&
              r.startTime.day == d.day)
          .fold<double>(0, (s, r) => s + r.distanceKm);
    });
    final maxDist = dayDistances.fold<double>(1.0, (a, b) => a > b ? a : b);

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
                  Text('Performance',
                      style: AppTextStyles.sageTitle.copyWith(fontSize: 20)),
                  Text('Last 7 days', style: AppTextStyles.sageSubtitle),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Distance',
                    style: AppTextStyles.sageSubtitle.copyWith(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final h = (dayDistances[i] / maxDist * 90).clamp(4.0, 90.0);
                final isToday = i == 6;
                return _buildBar(h, dayLabels[i], isAccent: isToday);
              }),
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
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          width: 28,
          height: height,
          decoration: BoxDecoration(
            color: isAccent
                ? AppColors.sageGreen
                : AppColors.sageGreenLight.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        const SizedBox(height: 10),
        Text(label,
            style: AppTextStyles.sageSubtitle.copyWith(
                fontSize: 11,
                fontWeight: isAccent ? FontWeight.w700 : FontWeight.w400,
                color: isAccent ? AppColors.sageGreen : AppColors.sageTextMuted)),
      ],
    );
  }

  // ── HISTORY TILE ──
  Widget _buildHistoryTile(RunRecord run) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.sageGreenLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(run.type.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(run.type.label,
                    style: AppTextStyles.sageTitle.copyWith(fontSize: 16)),
                const SizedBox(height: 2),
                Text(
                  '${run.distanceKm.toStringAsFixed(2)} km  •  ${run.formattedDuration}  •  ${run.steps} steps',
                  style: AppTextStyles.sageSubtitle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${run.startTime.day}/${run.startTime.month}',
                style: AppTextStyles.sageSubtitle
                    .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Text(
                run.formattedPace,
                style: AppTextStyles.sageSubtitle
                    .copyWith(fontSize: 11, color: AppColors.sageGreen),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── START CTA ──
  Widget _buildNextRunCTA(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GoalSelectionScreen()),
        );
        _loadData(); // Refresh after returning
      },
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [Color(0xFF2D6A4F), Color(0xFF5B7E5F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.sageGreen.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: -40,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ready for\nyour next run?',
                          style: AppTextStyles.sageTitle.copyWith(
                              color: Colors.white, fontSize: 26, height: 1.2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Set your goal and hit the road',
                          style: AppTextStyles.sageSubtitle
                              .copyWith(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 32),
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
