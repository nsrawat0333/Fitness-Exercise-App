import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/run_data.dart';
import '../../services/location_service.dart';
import 'active_run_screen.dart';

/// Smart Fitness Form – select run type, set distance/time/calorie/step targets.
class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen>
    with SingleTickerProviderStateMixin {
  RunType _selectedType = RunType.roadRun;

  final _distanceCtrl = TextEditingController(text: '5.0');
  final _timeCtrl = TextEditingController(text: '30');
  final _caloriesCtrl = TextEditingController();
  final _stepsCtrl = TextEditingController();

  bool _showOptional = false;

  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
  }

  @override
  void dispose() {
    _distanceCtrl.dispose();
    _timeCtrl.dispose();
    _caloriesCtrl.dispose();
    _stepsCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _startRun() async {
    final dist = double.tryParse(_distanceCtrl.text) ?? 5.0;
    final mins = int.tryParse(_timeCtrl.text) ?? 30;
    final cal = double.tryParse(_caloriesCtrl.text);
    final steps = int.tryParse(_stepsCtrl.text);

    // Pre-request permissions before launching the heavy Google Map View
    // This prevents Android from killing the backgrounded Activity
    bool hasPermissions = await LocationService.ensurePermissions();
    if (!hasPermissions && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are required to start a run.')),
      );
      return;
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActiveRunScreen(
          runType: _selectedType,
          targetDistanceKm: dist,
          targetDurationMin: mins,
          targetCalories: cal,
          targetSteps: steps,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sageDark,
      body: SafeArea(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── BACK + STEP LABEL ──
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SMART FITNESS PLAN',
                          style: AppTextStyles.sageSubtitle.copyWith(
                            color: AppColors.sageGreen,
                            fontSize: 10,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text('Choose Run Type',
                        style: AppTextStyles.sageTitle
                            .copyWith(color: Colors.white, fontSize: 30)),
                    const SizedBox(height: 8),
                    Text(
                      'Select your terrain and set goals for this session.',
                      style: AppTextStyles.sageSubtitle
                          .copyWith(color: Colors.white60, fontSize: 15),
                    ),
                    const SizedBox(height: 28),

                    // ── RUN TYPE CARDS ──
                    ...RunType.values.map((type) {
                      final isSelected = _selectedType == type;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedType = type),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.sageGreen
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.sageGreen
                                      : Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(type.emoji,
                                      style: const TextStyle(fontSize: 24)),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(type.label,
                                        style: AppTextStyles.sageCardTitle
                                            .copyWith(fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(
                                      type.tip,
                                      style: AppTextStyles.sageSubtitle
                                          .copyWith(
                                              color: Colors.white54,
                                              fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle,
                                    color: AppColors.sageGreen, size: 24),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // ── TARGET INPUTS ──
                    Text('Set Targets',
                        style: AppTextStyles.sageTitle
                            .copyWith(color: Colors.white, fontSize: 22)),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            label: 'Distance (km)',
                            controller: _distanceCtrl,
                            icon: Icons.straighten,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInput(
                            label: 'Time (min)',
                            controller: _timeCtrl,
                            icon: Icons.timer_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── OPTIONAL TOGGLE ──
                    GestureDetector(
                      onTap: () =>
                          setState(() => _showOptional = !_showOptional),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Optional Targets',
                                style: AppTextStyles.sageSubtitle.copyWith(
                                    color: Colors.white70, fontSize: 14)),
                            AnimatedRotation(
                              turns: _showOptional ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(Icons.expand_more,
                                  color: Colors.white54),
                            ),
                          ],
                        ),
                      ),
                    ),

                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildInput(
                                label: 'Calories',
                                controller: _caloriesCtrl,
                                icon: Icons.local_fire_department,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInput(
                                label: 'Steps',
                                controller: _stepsCtrl,
                                icon: Icons.directions_walk,
                              ),
                            ),
                          ],
                        ),
                      ),
                      crossFadeState: _showOptional
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),

                    const SizedBox(height: 28),

                    // ── TERRAIN TIP ──
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.sageGreen.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: AppColors.sageGreen.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline,
                              color: AppColors.sageGreen, size: 24),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Terrain Tip',
                                    style: AppTextStyles.sageCardTitle.copyWith(
                                        color: AppColors.sageGreen,
                                        fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedType.tip,
                                  style: AppTextStyles.sageSubtitle.copyWith(
                                      color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── FLOATING START BUTTON ──
              Positioned(
                bottom: 40,
                left: 24,
                right: 24,
                child: GestureDetector(
                  onTap: _startRun,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.sageGreen.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 28),
                        const SizedBox(width: 8),
                        Text('Start Run',
                            style: AppTextStyles.sageCardTitle
                                .copyWith(fontSize: 18, letterSpacing: 0.5)),
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

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: AppTextStyles.sageCardTitle.copyWith(fontSize: 16),
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.sageGreen, size: 20),
          labelText: label,
          labelStyle:
              AppTextStyles.sageSubtitle.copyWith(color: Colors.white38, fontSize: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
