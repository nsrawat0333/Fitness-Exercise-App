import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/gym_user_data.dart';
import '../../../services/home_workout_service.dart';
import 'home_workout_program_screen.dart';

/// User form screen for setting up a personalized Home Workout program.
///
/// Collects: focus area, fitness level, goal, and number of weeks.
class HomeWorkoutSetupScreen extends StatefulWidget {
  const HomeWorkoutSetupScreen({super.key});

  @override
  State<HomeWorkoutSetupScreen> createState() => _HomeWorkoutSetupScreenState();
}

class _HomeWorkoutSetupScreenState extends State<HomeWorkoutSetupScreen> {
  String _selectedFocusArea = 'Full Body';
  String _selectedLevel = 'Beginner';
  String _selectedGoal = 'Muscle Gain';
  int _selectedWeeks = 4;

  static const _focusAreas = [
    {'name': 'Full Body', 'icon': Icons.accessibility_new, 'color': Color(0xFF3B82F6)},
    {'name': 'Chest', 'icon': Icons.favorite, 'color': Color(0xFFEF4444)},
    {'name': 'Back', 'icon': Icons.airline_seat_flat, 'color': Color(0xFF8B5CF6)},
    {'name': 'Shoulders', 'icon': Icons.expand, 'color': Color(0xFFF59E0B)},
    {'name': 'Biceps', 'icon': Icons.fitness_center, 'color': Color(0xFF10B981)},
    {'name': 'Triceps', 'icon': Icons.sports_gymnastics, 'color': Color(0xFF06B6D4)},
    {'name': 'Abs', 'icon': Icons.grid_view, 'color': Color(0xFFF97316)},
    {'name': 'Legs', 'icon': Icons.directions_run, 'color': Color(0xFF6366F1)},
    {'name': 'Glutes', 'icon': Icons.directions_walk, 'color': Color(0xFFEC4899)},
  ];

  static const _levels = ['Beginner', 'Intermediate', 'Advanced'];
  static const _goals = ['Weight Loss', 'Muscle Gain', 'Strength'];

  void _onGenerate() {
    final userData = GymUserData();
    userData.homeWorkoutFocusArea = _selectedFocusArea;
    userData.homeWorkoutLevel = _selectedLevel;
    userData.homeWorkoutGoal = _selectedGoal;
    userData.homeWorkoutWeeks = _selectedWeeks;

    final focusKey = _selectedFocusArea.toLowerCase().replaceAll(' ', '_');
    final program = HomeWorkoutService.generateProgram(
      focusArea: focusKey,
      weeks: _selectedWeeks,
      level: _selectedLevel,
      goal: _selectedGoal,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeWorkoutProgramScreen(program: program),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Workout Program',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ── STEP 1: Focus Area ──
              _buildSectionTitle('1', 'Select Focus Area'),
              const SizedBox(height: 12),
              _buildFocusAreaGrid(),

              const SizedBox(height: 28),

              // ── STEP 2: Fitness Level ──
              _buildSectionTitle('2', 'Your Fitness Level'),
              const SizedBox(height: 12),
              _buildLevelSelector(),

              const SizedBox(height: 28),

              // ── STEP 3: Goal ──
              _buildSectionTitle('3', 'Your Goal'),
              const SizedBox(height: 12),
              _buildGoalSelector(),

              const SizedBox(height: 28),

              // ── STEP 4: Weeks ──
              _buildSectionTitle('4', 'Program Duration'),
              const SizedBox(height: 12),
              _buildWeeksSlider(),

              const SizedBox(height: 32),

              // ── Summary ──
              _buildSummaryCard(),

              const SizedBox(height: 20),

              // ── Generate Button ──
              GestureDetector(
                onTap: _onGenerate,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'GENERATE PROGRAM',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String step, String title) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFF3B82F6),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            step,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildFocusAreaGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: _focusAreas.length,
      itemBuilder: (context, index) {
        final area = _focusAreas[index];
        final name = area['name'] as String;
        final icon = area['icon'] as IconData;
        final color = area['color'] as Color;
        final isSelected = _selectedFocusArea == name;

        return GestureDetector(
          onTap: () => setState(() => _selectedFocusArea = name),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? color : const Color(0xFFE5E7EB),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: isSelected ? color : Colors.grey[500]),
                const SizedBox(height: 6),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? color : Colors.grey[700],
                  ),
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_circle, color: color, size: 14),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLevelSelector() {
    final levelIcons = [Icons.trending_up, Icons.bolt, Icons.local_fire_department];
    final levelDescriptions = [
      'Light exercises, longer rest',
      'Moderate intensity & pace',
      'High intensity, short rest',
    ];

    return Column(
      children: List.generate(_levels.length, (i) {
        final level = _levels[i];
        final isSelected = _selectedLevel == level;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () => setState(() => _selectedLevel = level),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isSelected ? null : Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Icon(levelIcons[i], size: 22,
                      color: isSelected ? Colors.white : const Color(0xFF3B82F6)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          levelDescriptions[i],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isSelected ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Color(0xFF3B82F6), size: 14),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGoalSelector() {
    final goalIcons = [Icons.monitor_weight, Icons.fitness_center, Icons.flash_on];
    final goalColors = [
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
    ];

    return Row(
      children: List.generate(_goals.length, (i) {
        final goal = _goals[i];
        final isSelected = _selectedGoal == goal;
        final color = goalColors[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i > 0 ? 10 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedGoal = goal),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 100,
                decoration: BoxDecoration(
                  color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? color : const Color(0xFFE5E7EB),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(goalIcons[i], size: 28, color: isSelected ? color : Colors.grey[500]),
                    const SizedBox(height: 6),
                    Text(
                      goal,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? color : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildWeeksSlider() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_selectedWeeks Weeks',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF3B82F6),
                ),
              ),
              Text(
                '${_selectedWeeks * 7} days',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              activeTrackColor: const Color(0xFF3B82F6),
              inactiveTrackColor: const Color(0xFFE5E7EB),
              thumbColor: const Color(0xFF3B82F6),
              overlayColor: const Color(0xFF3B82F6).withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _selectedWeeks.toDouble(),
              min: 1,
              max: 12,
              divisions: 11,
              onChanged: (v) => setState(() => _selectedWeeks = v.round()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1 week', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
              Text('12 weeks', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3B82F6).withValues(alpha: 0.08),
            const Color(0xFF6366F1).withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Program Summary',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(Icons.my_location, 'Focus', _selectedFocusArea),
          _buildSummaryRow(Icons.trending_up, 'Level', _selectedLevel),
          _buildSummaryRow(Icons.flag, 'Goal', _selectedGoal),
          _buildSummaryRow(Icons.calendar_month, 'Duration', '$_selectedWeeks weeks'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF3B82F6)),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
