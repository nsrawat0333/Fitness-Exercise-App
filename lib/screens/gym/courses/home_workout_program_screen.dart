import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/home_workout_models.dart';
import '../../../data/gym_challenge_data.dart';
import 'workout_flow_screen.dart';

/// Displays the generated Home Workout program with week/day breakdown.
class HomeWorkoutProgramScreen extends StatefulWidget {
  final HomeWorkoutProgram program;

  const HomeWorkoutProgramScreen({super.key, required this.program});

  @override
  State<HomeWorkoutProgramScreen> createState() =>
      _HomeWorkoutProgramScreenState();
}

class _HomeWorkoutProgramScreenState extends State<HomeWorkoutProgramScreen> {
  int _expandedWeek = 0; // 0-indexed, first week expanded by default

  @override
  Widget build(BuildContext context) {
    final program = widget.program;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(program),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildStatsRow(program),
                  const SizedBox(height: 24),
                  _buildProgressIndicator(program),
                  const SizedBox(height: 28),
                  Text(
                    'Weekly Breakdown',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(program.weeks.length, (i) {
                    return _buildWeekCard(program.weeks[i], i);
                  }),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(HomeWorkoutProgram program) {
    final focusCapitalized =
        program.focusArea[0].toUpperCase() + program.focusArea.substring(1);

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: const Color(0xFF3B82F6),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${program.level} • ${program.goal}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$focusCapitalized\nWorkout Program',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${program.totalWeeks} Weeks • Progressive Overload',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(HomeWorkoutProgram program) {
    return Row(
      children: [
        _buildStatChip(Icons.calendar_month, '${program.totalWeeks}',
            'Weeks', const Color(0xFF3B82F6)),
        const SizedBox(width: 10),
        _buildStatChip(Icons.fitness_center, '${program.totalWorkoutDays}',
            'Workouts', const Color(0xFF10B981)),
        const SizedBox(width: 10),
        _buildStatChip(Icons.hotel, '${program.totalRestDays}',
            'Rest Days', const Color(0xFFF59E0B)),
      ],
    );
  }

  Widget _buildStatChip(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.outfit(
                  fontSize: 20, fontWeight: FontWeight.w900, color: color),
            ),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(HomeWorkoutProgram program) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progressive Overload',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const Icon(Icons.trending_up, color: Color(0xFF10B981), size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(program.totalWeeks, (i) {
              double progress = program.totalWeeks <= 1
                  ? 1.0
                  : i / (program.totalWeeks - 1);
              return Expanded(
                child: Container(
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: Color.lerp(
                        const Color(0xFF10B981), const Color(0xFFEF4444), progress),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Easy',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: const Color(0xFF10B981))),
              Text('Peak',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: const Color(0xFFEF4444))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekCard(HomeWorkoutWeek week, int index) {
    final isExpanded = _expandedWeek == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isExpanded
                ? const Color(0xFF3B82F6).withValues(alpha: 0.4)
                : const Color(0xFFE5E7EB),
            width: isExpanded ? 2 : 1,
          ),
          boxShadow: isExpanded
              ? [
                  BoxShadow(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : null,
        ),
        child: Column(
          children: [
            // Week header
            GestureDetector(
              onTap: () => setState(() {
                _expandedWeek = isExpanded ? -1 : index;
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'W${week.weekNumber}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Week ${week.weekNumber}',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${week.theme} • ${week.difficultyLabel}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildDifficultyBadge(week.difficultyLabel),
                    const SizedBox(width: 8),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ),
            ),

            // Expanded day list
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: week.days.map((day) {
                    return _buildDayRow(day, week.weekNumber);
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color badgeColor;
    switch (difficulty) {
      case 'Hard':
        badgeColor = const Color(0xFFEF4444);
        break;
      case 'Moderate':
        badgeColor = const Color(0xFFF59E0B);
        break;
      default:
        badgeColor = const Color(0xFF10B981);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficulty,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: badgeColor,
        ),
      ),
    );
  }

  Widget _buildDayRow(HomeWorkoutDay day, int weekNumber) {
    if (day.isRestDay) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.hotel, size: 18, color: Colors.green[600]),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Day ${day.dayNumber} — ${day.title}',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
            ),
            Text(
              'REST',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.green[600],
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        // Convert HomeExercise list to GymExercise list for WorkoutFlowScreen
        final gymExercises = day.exercises.map((e) {
          return GymExercise(
            name: e.name,
            durationSeconds: _parseDuration(e.duration),
            imageAsset: e.image,
            animationLottie: e.animation.isNotEmpty ? e.animation : null,
            instructions: e.steps,
          );
        }).toList();

        if (gymExercises.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkoutFlowScreen(
                exercises: gymExercises,
                dayIndex: (weekNumber - 1) * 7 + day.dayNumber,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.dayNumber}',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3B82F6),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.title,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${day.exercises.length} exercises • ${day.estimatedMinutes} min',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_circle_fill,
                color: Color(0xFF3B82F6), size: 28),
          ],
        ),
      ),
    );
  }

  int _parseDuration(String duration) {
    final match = RegExp(r'(\d+)').firstMatch(duration);
    return match != null ? int.parse(match.group(1)!) : 30;
  }
}
