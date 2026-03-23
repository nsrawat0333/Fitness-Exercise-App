import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../data/gym_challenge_data.dart';
import '../../services/yoga_service.dart';
import '../gym/courses/workout_flow_screen.dart';

class YogaCustomPlanScreen extends StatefulWidget {
  const YogaCustomPlanScreen({super.key});

  @override
  State<YogaCustomPlanScreen> createState() => _YogaCustomPlanScreenState();
}

class _YogaCustomPlanScreenState extends State<YogaCustomPlanScreen> {
  String _level = 'Beginner';
  String _goal = 'Weight Loss';
  double _duration = 20;

  final _levels = ['Beginner', 'Intermediate', 'Advanced'];
  final _goals = ['Weight Loss', 'Flexibility', 'Relax', 'Strength'];

  void _generateAndStart() {
    final session = YogaService.generateCustomPlan(
      level: _level,
      goal: _goal,
      durationMinutes: _duration.toInt(),
    );

    final gymExercises = session.poses.map((p) {
      return GymExercise(
        id: p.name.toLowerCase().replaceAll(' ', '_'),
        name: p.name,
        category: p.category,
        muscleGroup: p.focusAreas,
        difficulty: session.difficulty,
        durationSeconds: p.durationSeconds,
        performDuration: p.durationSeconds,
        instructions: p.steps,
        imageAsset: p.image,
        animationLottie: p.animation.isNotEmpty ? p.animation : null,
      );
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutFlowScreen(
          exercises: gymExercises,
          dayIndex: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Custom Plan',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Let us build the perfect yoga flow for exactly what you need right now.',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Level Selection
                    _buildSectionTitle('What is your experience level?'),
                    const SizedBox(height: 16),
                    _buildOptionsRow(_levels, _level, (v) => setState(() => _level = v)),

                    const SizedBox(height: 32),

                    // Goal Selection
                    _buildSectionTitle('What is your priority today?'),
                    const SizedBox(height: 16),
                    _buildOptionsGrid(_goals, _goal, (v) => setState(() => _goal = v)),

                    const SizedBox(height: 32),

                    // Duration Selection
                    _buildSectionTitle('How much time do you have?'),
                    const SizedBox(height: 8),
                    Text(
                      '${_duration.toInt()} minutes',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF7C4DFF),
                      ),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF7C4DFF),
                        inactiveTrackColor: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
                        thumbColor: const Color(0xFF7C4DFF),
                        overlayColor: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
                        trackHeight: 6,
                      ),
                      child: Slider(
                        value: _duration,
                        min: 10,
                        max: 60,
                        divisions: 10,
                        onChanged: (val) => setState(() => _duration = val),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('10 min', style: GoogleFonts.inter(color: Colors.grey)),
                        Text('60 min', style: GoogleFonts.inter(color: Colors.grey)),
                      ],
                    ),

                    const SizedBox(height: 60),

                    // Generate Button
                    GestureDetector(
                      onTap: _generateAndStart,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C4DFF), Color(0xFF9E7CFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C4DFF).withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Generate Yoga Flow',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
          ),
          const Spacer(),
          const Icon(Icons.auto_awesome, color: Color(0xFF7C4DFF), size: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildOptionsRow(List<String> options, String selected, Function(String) onSelect) {
    return Row(
      children: options.map((opt) {
        final isSelected = opt == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(opt),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF7C4DFF) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? const Color(0xFF7C4DFF) : Colors.grey.withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: Text(
                  opt,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOptionsGrid(List<String> options, String selected, Function(String) onSelect) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: options.map((opt) {
        final isSelected = opt == selected;
        return GestureDetector(
          onTap: () => onSelect(opt),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF7C4DFF).withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF7C4DFF) : Colors.grey.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                opt,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF7C4DFF) : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
