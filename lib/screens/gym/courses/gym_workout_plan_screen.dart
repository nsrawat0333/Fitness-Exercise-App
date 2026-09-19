import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/gym_challenge_data.dart';
import '../../../data/exercise_assets.dart';
import 'workout_flow_screen.dart';

class GymWorkoutPlanScreen extends StatelessWidget {
  final String workoutName;
  final List<GymExercise> exerciseList;

  const GymWorkoutPlanScreen({
    super.key,
    required this.workoutName,
    this.exerciseList = const [],
  });

  @override
  Widget build(BuildContext context) {
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
          'Workout Plan',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Text(
                  'Workout Plan',
                  style: GoogleFonts.outfit(
                     fontSize: 16,
                     fontWeight: FontWeight.w600,
                     color: const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  workoutName,
                  style: GoogleFonts.outfit(
                     fontSize: 28,
                     fontWeight: FontWeight.w900,
                     color: Colors.black,
                     height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${exerciseList.isNotEmpty ? exerciseList.length : 0} Exercises • ${(exerciseList.fold(0, (sum, item) => sum + item.durationSeconds) / 60).ceil()} mins total',
                  style: GoogleFonts.inter(
                     fontSize: 14,
                     color: Colors.grey[600],
                  ),
                ),
               ],
            ),
          ),
          Expanded(
            child: exerciseList.isEmpty
                ? Center(
                    child: Text(
                      'No exercises found for this plan.',
                      style: GoogleFonts.inter(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: exerciseList.length,
                    itemBuilder: (context, index) {
                      return _buildExerciseRow(exerciseList[index], index);
                    },
                  ),
          ),
          _buildStartWorkoutButton(context),
        ],
      ),
    );
  }

  Widget _buildExerciseRow(GymExercise exercise, int index) {
    String formatTime(int seconds) {
      final m = (seconds / 60).floor().toString().padLeft(2, '0');
      final s = (seconds % 60).toString().padLeft(2, '0');
      return '$m:$s';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          // Drag handle icon
          Icon(Icons.drag_indicator, color: Colors.grey[300]),
          const SizedBox(width: 12),
          // Exercise image placeholder
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ExerciseMediaWidget(
                assetPath: exercise.animationLottie ?? exercise.imageAsset ?? GymChallengeData.getFallbackImage(exercise.name),
                fit: BoxFit.cover,
                isThumbnail: true,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  exercise.reps.isNotEmpty ? exercise.reps : formatTime(exercise.durationSeconds),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartWorkoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: exerciseList.isEmpty 
              ? null
              : () {
                  // Navigate to the real work flow!
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (_) => WorkoutFlowScreen(
                      exercises: exerciseList,
                      dayIndex: 1, // Optional: just pass 1 for custom plans.
                    )
                  ));
                },
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(28),
            ),
            alignment: Alignment.center,
            child: Text(
              'START WORKOUT',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
