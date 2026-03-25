import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../constants/app_colors.dart';
import '../../models/yoga_models.dart';
import '../../data/gym_challenge_data.dart';
import '../gym/courses/workout_flow_screen.dart';

class YogaCourseDetailScreen extends StatelessWidget {
  final YogaSession session;

  const YogaCourseDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    int totalDays;
    if (session.difficulty == 'Beginner') {
      totalDays = 7;
    } else if (session.difficulty == 'Intermediate') {
      totalDays = 14;
    } else {
      totalDays = 30;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 24),
                  _buildDescription(),
                  const SizedBox(height: 24),
                  _buildPosesList(),
                  const SizedBox(height: 32),
                  _buildProgramOverview(totalDays),
                  const SizedBox(height: 100),
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
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFFF9F7F3),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8),
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
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B7E5F), Color(0xFF3D8B6E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 40,
              child: Icon(
                Icons.self_improvement,
                size: 140,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            // Top pose animation
            if (session.poses.isNotEmpty && session.poses.first.animation.isNotEmpty)
              Positioned(
                right: 20,
                top: 60,
                width: 150,
                height: 150,
                child: Lottie.asset(
                  session.poses.first.animation,
                  fit: BoxFit.contain,
                ),
              ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      session.difficulty.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    session.title,
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
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

  Widget _buildHeaderInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoChip(Icons.schedule, session.duration),
        _buildInfoChip(Icons.bolt, session.difficulty),
        _buildInfoChip(Icons.self_improvement, '${session.poses.length} Poses'),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF5B7E5F)),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
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
          'About This Course',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'A carefully curated yoga course designed to match your ${session.difficulty.toLowerCase()} level. '
          'Each session focuses on improving your flexibility, strength, and mindfulness through '
          'targeted yoga poses with proper breathing techniques.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildPosesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Poses in This Course',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...session.poses.asMap().entries.map((entry) {
          final i = entry.key;
          final pose = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: pose.animation.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Lottie.asset(pose.animation, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.self_improvement, color: Color(0xFF5B7E5F), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pose.name,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pose.sanskritName,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${pose.durationSeconds}s',
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5B7E5F).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              pose.category.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF5B7E5F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '${i + 1}',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF5B7E5F).withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProgramOverview(int totalDays) {
    final dayTitles = [
      'Warm-Up Flow', 'Core Awakening', 'Rest & Recovery',
      'Strength Builder', 'Flexibility Focus', 'Balance Challenge',
      'Deep Stretch', 'Power Yoga', 'Restorative Session',
      'Full Body Flow', 'Spine Health', 'Active Recovery',
      'Peak Practice', 'Total Control', 'Rest Day',
      'Progressive Flow', 'Endurance Yoga', 'Twist & Tone',
      'Core Intensive', 'Meditation Flow', 'Balanced Practice',
      'Dynamic Sequence', 'Warrior Flow', 'Calm & Center',
      'Advanced Flow', 'Mind-Body Fusion', 'Power Stretch',
      'Integration Day', 'Challenge Flow', 'Final Practice',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Program Overview',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$totalDays Day Plan • ${session.difficulty}',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(totalDays, (i) {
          int day = i + 1;
          bool isUnlocked = day == 1;
          String title = dayTitles[i % dayTitles.length];
          int mins = 10 + (i * 2) % 25;

          return _buildDayRow('Day $day', title, '$mins mins', isUnlocked, day);
        }),
      ],
    );
  }

  Widget _buildDayRow(String day, String title, String time, bool isUnlocked, int dayIndex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFF5F2ED),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              isUnlocked ? Icons.play_arrow : Icons.lock_outline,
              color: isUnlocked ? const Color(0xFF5B7E5F) : Colors.grey[400],
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
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isUnlocked ? AppColors.textPrimary : Colors.grey[500],
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
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          // Convert YogaPoses to GymExercise for WorkoutFlowScreen
          final gymExercises = session.poses.map((p) {
            return GymExercise(
              id: p.name.toLowerCase().replaceAll(' ', '_'),
              name: p.name,
              category: p.category,
              muscleGroup: p.focusAreas,
              difficulty: session.difficulty.toLowerCase(),
              durationSeconds: p.durationSeconds,
              performDuration: p.durationSeconds,
              previewDuration: 20, // Increased preparation time for yoga poses
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
        },
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF5B7E5F),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B7E5F).withValues(alpha: 0.3),
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
