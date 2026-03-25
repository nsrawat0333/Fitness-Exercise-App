import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../data/gym_challenge_data.dart';
import '../../models/yoga_models.dart';
import '../../services/yoga_service.dart';
import '../gym/courses/workout_flow_screen.dart';

class Yoga30DayScreen extends StatefulWidget {
  const Yoga30DayScreen({super.key});

  @override
  State<Yoga30DayScreen> createState() => _Yoga30DayScreenState();
}

class _Yoga30DayScreenState extends State<Yoga30DayScreen> {
  late List<YogaDay> _program;
  final int _currentDay = 1; // Simulated progress

  @override
  void initState() {
    super.initState();
    _program = YogaService.generate30DayProgram();
  }

  void _startWorkout(YogaDay day) {
    if (day.isRestDay) return;

    // Convert YogaPose to GymExercise for WorkoutFlowScreen
    final gymExercises = day.poses.map((p) {
      return GymExercise(
        id: p.name.toLowerCase().replaceAll(' ', '_'),
        name: p.name,
        category: p.category,
        muscleGroup: p.focusAreas,
        difficulty: day.phase,
        durationSeconds: p.durationSeconds,
        performDuration: p.durationSeconds,
        previewDuration: 20, // Increased preparation time for yoga poses
        instructions: p.steps,
        imageAsset: p.image,
        animationLottie: p.animation.isNotEmpty ? p.animation : null,
        videoAsset: null,
      );
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutFlowScreen(
          exercises: gymExercises,
          dayIndex: day.dayNumber,
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
            _buildProgressHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                itemCount: _program.length,
                itemBuilder: (context, index) {
                  final day = _program[index];
                  final isUnlocked = day.dayNumber <= _currentDay;
                  final isCompleted = day.dayNumber < _currentDay;
                  final isCurrent = day.dayNumber == _currentDay;

                  return _buildDayCard(day, isUnlocked, isCompleted, isCurrent);
                },
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
          const Expanded(
            child: Center(
              child: Text('30 Days Yoga',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    final progress = (_currentDay - 1) / 30;
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4A574), Color(0xFFC8956C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A574).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Progress',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                '${((_currentDay - 1) / 30 * 100).toInt()}%',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Keep it up! Consistency is key.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(
      YogaDay day, bool isUnlocked, bool isCompleted, bool isCurrent) {
    Color phaseColor;
    switch (day.phase) {
      case 'Beginner':
        phaseColor = const Color(0xFF5B7E5F);
        break;
      case 'Foundation':
        phaseColor = const Color(0xFFD4A574);
        break;
      case 'Intermediate':
        phaseColor = const Color(0xFF5EC6C6);
        break;
      default:
        phaseColor = const Color(0xFF7C4DFF);
    }

    return GestureDetector(
      onTap: () {
        if (isUnlocked && !day.isRestDay) {
          _startWorkout(day);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: isCurrent
              ? Border.all(color: phaseColor, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
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
            // Day Circle
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isCompleted
                    ? phaseColor
                    : phaseColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white)
                    : Text(
                        '${day.dayNumber}',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: phaseColor,
                        ),
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
                    day.isRestDay ? 'Rest & Recovery' : day.title,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isUnlocked
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 14,
                          color: isUnlocked
                              ? AppColors.textSecondary
                              : Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        day.duration,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: isUnlocked
                              ? AppColors.textSecondary
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.bolt_outlined,
                          size: 14, color: phaseColor),
                      const SizedBox(width: 4),
                      Text(
                        day.phase,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: phaseColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Lock Icon
            if (!isUnlocked)
              const Icon(Icons.lock_outline, color: Colors.grey, size: 24)
            else if (isCurrent && !day.isRestDay)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: phaseColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow_rounded,
                    color: phaseColor, size: 24),
              ),
          ],
        ),
      ),
    );
  }
}
