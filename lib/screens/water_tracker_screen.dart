import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/water_intake_model.dart';
import '../services/water_storage_service.dart';

/// Water Tracker Screen – exact replica of the Stitch design.
class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen>
    with TickerProviderStateMixin {
  late AnimationController _fillCtrl;
  late Animation<double> _fillAnim;
  late AnimationController _addWaterCtrl;
  late Animation<double> _addWaterAnim;

  final _waterService = WaterStorageService();
  late WaterIntakeModel _data;

  @override
  void initState() {
    super.initState();
    _data = _waterService.waterDataNotifier.value;

    _fillCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fillAnim = CurvedAnimation(parent: _fillCtrl, curve: Curves.easeOutCubic);
    _fillCtrl.forward();

    _addWaterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _addWaterAnim =
        CurvedAnimation(parent: _addWaterCtrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _fillCtrl.dispose();
    _addWaterCtrl.dispose();
    super.dispose();
  }

  void _drinkWater() {
    final vessel = WaterIntakeModel.vessels[_data.selectedVesselIndex];
    
    // Add history entry
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';
    final timeStr =
        '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';
        
    final label = vessel.ml >= 500
        ? 'Large Bottle'
        : vessel.ml >= 250
            ? 'Medium Glass'
            : 'Small Cup';

    _waterService.addIntake(vessel.ml, label, timeStr);

    // Trigger add-water pulse animation
    _addWaterCtrl.forward(from: 0);

    // Reset and replay fill animation
    _fillCtrl.forward(from: 0);
  }

  void _showUpdateGoalDialog() {
    final controller =
        TextEditingController(text: (_data.dailyGoalMl / 1000).toStringAsFixed(1));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.waterScreenBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Update Daily Goal', style: AppTextStyles.heading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                suffixText: 'Liters',
                suffixStyle: AppTextStyles.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.waterTeal, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              final val = double.tryParse(controller.text);
              if (val != null && val > 0) {
                _waterService.updateGoal((val * 1000).round());
                _fillCtrl.forward(from: 0);
              }
              Navigator.pop(ctx);
            },
            child: Text('Update',
                style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.waterTeal, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showRemindersSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.waterScreenBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hydration Reminders', style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                    Text('Auto reminders run every 2 hours from 8 AM to 8 PM. Night alerts stay off.',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  ...List.generate(_data.reminders.length, (i) {
                    final rem = _data.reminders[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final newTime = await showTimePicker(
                                context: context,
                                initialTime: rem.time,
                              );
                              if (newTime != null) {
                                setSheetState(() => _data.reminders[i].time = newTime);
                                setState(() => _data.reminders[i].time = newTime);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.textMuted
                                        .withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                rem.time.format(context),
                                style: AppTextStyles.heading3,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: rem.enabled,
                            onChanged: (val) {
                              setSheetState(() => _data.reminders[i].enabled = val);
                              setState(() => _data.reminders[i].enabled = val);
                            },
                            activeThumbColor: AppColors.waterTeal,
                            activeTrackColor: AppColors.waterTealLight,
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.waterTeal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('Save Reminders',
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── Build ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WaterIntakeModel>(
      valueListenable: _waterService.waterDataNotifier,
      builder: (context, dynamicData, _) {
        _data = dynamicData; // update local ref
        return Scaffold(
          backgroundColor: AppColors.waterScreenBg,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildAppBar(context),
                      const SizedBox(height: 24),
                      _buildWaterGlass(),
                      const SizedBox(height: 24),
                      _buildTodayGoalRow(),
                      const SizedBox(height: 20),
                      _buildWeeklyMonthlyRow(),
                      const SizedBox(height: 28),
                      _buildVesselSelector(),
                      const SizedBox(height: 20),
                      _buildReminderToggle(),
                      const SizedBox(height: 28),
                      _buildTodayHistory(),
                      const SizedBox(height: 100), // space for floating button
                    ],
                  ),
                ),
                // ── Floating Drink Water Button ──
                Positioned(
                  bottom: 24,
                  left: 20,
                  right: 20,
                  child: _buildDrinkWaterButton(),
                ),
              ],
            ),
          ),
        );
      },
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
            child: const Icon(Icons.arrow_back_ios_new,
                size: 18, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Text('Water Intake',
            style: AppTextStyles.heading3
                .copyWith(color: AppColors.waterTeal)),
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.more_vert,
                size: 20, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  // ── 2. Water Glass Card ────────────────────────────────
  Widget _buildWaterGlass() {
    return AnimatedBuilder(
      animation: _fillAnim,
      builder: (context, _) {
        final animProgress = _data.progressFraction * _fillAnim.value;
        return Center(
          child: Container(
            width: 220,
            height: 230,
            decoration: BoxDecoration(
              color: AppColors.waterGlassBg,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // Water fill
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      height: 230 * animProgress,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.waterGlassFill.withValues(alpha: 0.7),
                            AppColors.waterTeal,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Wave effect (subtle)
                  Positioned(
                    bottom: 230 * animProgress - 12,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      size: const Size(double.infinity, 14),
                      painter: _WavePainter(
                          color: AppColors.waterGlassFill
                              .withValues(alpha: 0.5)),
                    ),
                  ),
                  // Center text
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: (_data.currentLiters *
                                        _fillAnim.value)
                                    .toStringAsFixed(1),
                                style: AppTextStyles.waterIntakeValue.copyWith(
                                  color: animProgress > 0.5
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text: 'L',
                                style: AppTextStyles.waterIntakeUnit.copyWith(
                                  color: animProgress > 0.5
                                      ? Colors.white70
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'OF ${_data.goalLiters.toStringAsFixed(1)}L GOAL',
                          style: AppTextStyles.waterGoalLabel.copyWith(
                            color: animProgress > 0.4
                                ? Colors.white70
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── 3. Today's Goal Row ────────────────────────────────
  Widget _buildTodayGoalRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today's Goal",
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(
                '${_data.goalLiters.toStringAsFixed(0)} Liters',
                style: AppTextStyles.heading3,
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: _showUpdateGoalDialog,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.waterScreenBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.textMuted.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Update Goal',
                style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 4. Weekly Avg / Monthly Reach ──────────────────────
  Widget _buildWeeklyMonthlyRow() {
    return Row(
      children: [
        // Weekly Avg Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('WEEKLY AVG', style: AppTextStyles.waterStatLabel),
                const SizedBox(height: 12),
                // Mini bar chart
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (i) {
                      final heights = [0.4, 0.6, 0.3, 0.8, 0.5, 0.7, 0.45];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500 + i * 80),
                          curve: Curves.easeOutCubic,
                          width: 6,
                          height: 40 * heights[i],
                          decoration: BoxDecoration(
                            color: AppColors.waterTeal
                                .withValues(alpha: 0.3 + heights[i] * 0.7),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 12),
                Text('1.8 L', style: AppTextStyles.waterStatValue),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Monthly Reach Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('MONTHLY REACH', style: AppTextStyles.waterStatLabel),
                const SizedBox(height: 12),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: AnimatedBuilder(
                    animation: _fillAnim,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _MonthlyRingPainter(
                            progress: 0.75 * _fillAnim.value),
                        child: Center(
                          child: Text(
                            '${(75 * _fillAnim.value).round()}%',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.waterGoalBrown,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text('24 Days', style: AppTextStyles.waterStatValue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── 5. Vessel Selector ─────────────────────────────────
  Widget _buildVesselSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Vessel', style: AppTextStyles.waterSectionTitle),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(WaterIntakeModel.vessels.length, (i) {
            final vessel = WaterIntakeModel.vessels[i];
            final isSelected = _data.selectedVesselIndex == i;
            return GestureDetector(
              onTap: () => setState(() => _data.selectedVesselIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 80,
                height: 90,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.waterVesselActive
                      : AppColors.waterVesselBg,
                  borderRadius: BorderRadius.circular(18),
                  border: isSelected
                      ? Border.all(color: AppColors.waterTeal, width: 2)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color:
                                  AppColors.waterTeal.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4)),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      vessel.icon,
                      size: 28,
                      color: isSelected
                          ? AppColors.waterTeal
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      vessel.label,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.waterTeal
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── 6. Hydration Reminder Toggle ───────────────────────
  Widget _buildReminderToggle() {
    return GestureDetector(
      onTap: _showRemindersSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.waterTealLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.notifications_active_outlined,
                  color: AppColors.waterTeal, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hydration Reminders',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(_data.reminderInterval,
                      style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Switch(
              value: _data.remindersEnabled,
              onChanged: (val) {
                _waterService.toggleReminders(val);
                if (val) _showRemindersSheet();
              },
              activeThumbColor: AppColors.waterTeal,
              activeTrackColor: AppColors.waterTealLight,
            ),
          ],
        ),
      ),
    );
  }

  // ── 7. Today's History ─────────────────────────────────
  Widget _buildTodayHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Today's History", style: AppTextStyles.waterSectionTitle),
            const Spacer(),
            Text('View All',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.waterTeal, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 16),
        ...List.generate(_data.history.length, (i) {
          final entry = _data.history[i];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + i * 100),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.waterTealLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.local_drink,
                          color: AppColors.waterTeal, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.label,
                              style: AppTextStyles.bodyMedium
                                  .copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(entry.time,
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Text(
                      '+${entry.amountMl}ml',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.waterTeal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── 8. Drink Water Button ──────────────────────────────
  Widget _buildDrinkWaterButton() {
    return GestureDetector(
      onTap: _drinkWater,
      child: AnimatedBuilder(
        animation: _addWaterAnim,
        builder: (context, _) {
          final scale = 1.0 + 0.05 * sin(_addWaterAnim.value * pi);
          return Transform.scale(
            scale: scale,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.waterTeal, AppColors.waterTealDark],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.waterTeal.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.water_drop, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    '+ Drink Water',
                    style: AppTextStyles.heading3.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ═══════════════════════════════════════════════════════════

/// Simple wave painter for the top of the water fill.
class _WavePainter extends CustomPainter {
  final Color color;

  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      path.lineTo(
        x,
        size.height / 2 +
            sin(x / size.width * 2 * pi) * size.height * 0.35,
      );
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => old.color != color;
}

/// Circular ring painter for the monthly reach percentage.
class _MonthlyRingPainter extends CustomPainter {
  final double progress;

  _MonthlyRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    const strokeWidth = 6.0;
    const startAngle = -pi / 2;
    const sweepFull = 2 * pi;

    // Track
    final trackPaint = Paint()
      ..color = AppColors.waterGlassBg
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepFull, false, trackPaint);

    // Progress
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = AppColors.waterGoalBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startAngle, sweepFull * progress.clamp(0.0, 1.0), false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MonthlyRingPainter old) =>
      old.progress != progress;
}
