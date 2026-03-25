import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../data/gym_challenge_data.dart';
import 'workout_flow_screen.dart';

class GymDailyWorkoutScreen extends StatelessWidget {
  final int dayIndex;
  final List<GymExercise>? customExercises;

  const GymDailyWorkoutScreen({
    super.key, 
    required this.dayIndex,
    this.customExercises,
  });

  @override
  Widget build(BuildContext context) {
    // Get the dynamic list of exercises
    final exercises = customExercises != null && customExercises!.isNotEmpty 
        ? customExercises! 
        : GymChallengeData.getExercisesForDay(dayIndex);
    
    final totalSeconds = exercises.fold<int>(0, (sum, e) => sum + e.durationSeconds);
    // Add rest time: 30s per exercise except the last one
    final totalDurationSec = totalSeconds + ((exercises.length - 1) * 30);
    final totalMins = (totalDurationSec / 60).round();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'DAY $dayIndex',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard('$totalMins mins', 'Duration'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard('${exercises.length}', 'Exercises'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Exercises',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Edit',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF005FF9),
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Color(0xFF005FF9), size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverPadding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100), // Spacing for button
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final ex = exercises[index];
                      return _buildExerciseRow(ex);
                    },
                    childCount: exercises.length,
                  ),
                ),
              ),
            ],
          ),
          
          // Floating Start Button
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 56,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WorkoutFlowScreen(exercises: exercises, dayIndex: dayIndex))
                  );
                },
                backgroundColor: const Color(0xFF005FF9),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                label: Text(
                  'Start',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String mainText, String subText) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            mainText,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseRow(GymExercise exercise) {
    String formatTime(int seconds) {
      final m = (seconds / 60).floor().toString().padLeft(2, '0');
      final s = (seconds % 60).toString().padLeft(2, '0');
      return '$m:$s';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          // Drag handle
          const Icon(Icons.drag_handle, color: Colors.grey),
          const SizedBox(width: 16),
          // Graphic / Animation
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: exercise.videoAsset != null
                ? const Icon(Icons.play_circle_fill, color: Color(0xFF005FF9), size: 30)
                : exercise.animationLottie != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Lottie.asset(
                          exercise.animationLottie!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.directions_run, color: Color(0xFF005FF9), size: 30),
          ),
          const SizedBox(width: 16),
          // Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatTime(exercise.durationSeconds),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Swap icon
          const Icon(Icons.swap_vert, color: Colors.grey),
        ],
      ),
    );
  }
}
