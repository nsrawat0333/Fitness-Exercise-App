import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/gym_user_data.dart';
import '../../../data/gym_challenge_data.dart'; // Add missing import
import 'gym_workout_plan_screen.dart';
import 'gym_daily_workout_screen.dart';

class GymCourseDetailScreen extends StatelessWidget {
  final String courseName;
  final String duration;
  final String difficulty;
  final String imagePath;
  final List<GymExercise>? exerciseList; // Added to carry the actual exercises

  const GymCourseDetailScreen({
    super.key,
    required this.courseName,
    required this.duration,
    required this.difficulty,
    required this.imagePath,
    this.exerciseList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 24),
                  _buildDescription(),
                  const SizedBox(height: 32),
                  _buildProgramOverview(context),
                  const SizedBox(height: 100), // spacing for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildStartButton(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withValues(alpha: 0.8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
            // Gradient Overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          courseName,
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildInfoChip(Icons.schedule, duration),
            _buildInfoChip(Icons.bolt, difficulty),
            _buildInfoChip(Icons.local_fire_department, 'Medium Burn'),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF3B82F6)),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Start your body-toning journey to target all muscle groups and build your dream body in record time. This program is specifically designed to maximize results through a scientifically backed routine.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildProgramOverview(BuildContext context) {
    int totalDays;
    if (difficulty == 'Beginner') {
      totalDays = 7;
    } else if (difficulty == 'Intermediate') {
      totalDays = 14;
    } else {
      totalDays = 30;
    }

    final userData = GymUserData();
    final dayTitles = [
      'Full Body Activation', 'Core & Stability', 'Rest & Recovery',
      'Strength Builder', 'Cardio Blast', 'Upper Body Focus',
      'Lower Body Focus', 'HIIT Session', 'Flexibility Day',
      'Power Training', 'Endurance Build', 'Active Recovery',
      'Peak Performance', 'Total Body Burn', 'Rest Day',
      'Progressive Overload', 'Muscle Endurance', 'Speed Training',
      'Core Intensive', 'Resistance Training', 'Plyometrics',
      'Balance & Stability', 'Circuit Training', 'Rest & Stretch',
      'High Volume', 'Functional Training', 'Explosive Power',
      'Tempo Training', 'Challenge Day', 'Final Push',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Program Overview',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$totalDays Day Plan • $difficulty',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(totalDays, (i) {
          int day = i + 1;
          bool isCompleted = userData.isDayCompleted(day);
          bool isUnlocked = userData.isDayUnlocked(day);
          String title = dayTitles[i % dayTitles.length];
          int mins = 10 + (i * 2) % 25;

          return _buildDayRow('Day $day', title, '$mins mins', isUnlocked, isCompleted, day, context);
        }),
      ],
    );
  }

  Widget _buildDayRow(String day, String title, String time, bool isUnlocked, bool isCompleted, int dayIndex, BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked && !isCompleted
          ? () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => GymDailyWorkoutScreen(
                  dayIndex: dayIndex,
                  customExercises: exerciseList,
                ),
              ));
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green.withValues(alpha: 0.15)
                    : isUnlocked
                        ? const Color(0xFFE3F2FD)
                        : const Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isCompleted
                    ? Icons.check
                    : isUnlocked
                        ? Icons.play_arrow
                        : Icons.lock_outline,
                color: isCompleted
                    ? Colors.green
                    : isUnlocked
                        ? const Color(0xFF3B82F6)
                        : Colors.grey[400],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isCompleted
                          ? Colors.green[700]
                          : isUnlocked
                              ? Colors.black
                              : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => GymWorkoutPlanScreen(
              workoutName: courseName,
              exerciseList: exerciseList ?? [], // Provide the exerciseList or empty array
            )
          ));
        },
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'START PLAN',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
