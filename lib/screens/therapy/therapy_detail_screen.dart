import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../constants/app_colors.dart';
import '../../data/gym_challenge_data.dart';
import '../gym/courses/workout_flow_screen.dart';
import 'therapy_screen.dart';

class TherapyDetailScreen extends StatefulWidget {
  final TherapyCategory category;

  const TherapyDetailScreen({super.key, required this.category});

  @override
  State<TherapyDetailScreen> createState() => _TherapyDetailScreenState();
}

class _TherapyDetailScreenState extends State<TherapyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final hasExercises = category.exercises.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${category.title} Relief',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: category.accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(category.icon, color: category.accentColor, size: 22),
                  ),
                ],
              ),
            ),

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Hero Banner ──
                    _buildHeroBanner(category),

                    const SizedBox(height: 28),

                    // ── About Section ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'About',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Targeted exercises designed to provide relief for ${category.title.toLowerCase()}. '
                        'Follow the guided session to reduce discomfort and improve mobility through proven therapeutic techniques.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Exercise List / Coming Soon ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Exercises',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (hasExercises)
                            Text(
                              '${category.exercises.length} exercises',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (hasExercises)
                      ...category.exercises.asMap().entries.map((entry) {
                        return _buildExerciseCard(entry.key, entry.value);
                      })
                    else
                      _buildComingSoonSection(category),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // ── Bottom Button ──
            if (hasExercises)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: GestureDetector(
                  onTap: () {
                    final gymExercises = category.exercises.map((exName) {
                      return GymExercise(
                        id: exName.replaceAll(' ', '_').toLowerCase(),
                        name: exName,
                        category: 'Therapy',
                        muscleGroup: [category.title],
                        difficulty: 'Beginner',
                        durationSeconds: 60,
                        instructions: ['Follow the animation and breathe deeply for $exName.'],
                        animationLottie: category.animationFolderPath != null 
                            ? '${category.animationFolderPath!}$exName.json' 
                            : null,
                        breathingDuration: 20,
                        previewDuration: 10,
                        performDuration: 60,
                        recoveryDuration: 20,
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
                    height: 60,
                    decoration: BoxDecoration(
                      color: category.accentColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: category.accentColor.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_circle_filled, color: Colors.white, size: 24),
                        const SizedBox(width: 10),
                        Text(
                          'Start Therapy Session',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(TherapyCategory category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              if (category.imagePath != null)
                Image.asset(
                  category.imagePath!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildGradientBg(category),
                )
              else
                _buildGradientBg(category),

              // Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      category.accentColor.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),

              // Text
              Positioned(
                left: 24,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'THERAPY',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.tagline,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
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
  }

  Widget _buildGradientBg(TherapyCategory category) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            category.accentColor,
            category.accentColor.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          category.icon,
          size: 80,
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(int index, String exerciseName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.category.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: widget.category.animationFolderPath != null
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Lottie.asset(
                          '${widget.category.animationFolderPath!}$exerciseName.json',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.self_improvement,
                            color: widget.category.accentColor,
                            size: 24,
                          ),
                        ),
                      ),
                    )
                  : Icon(
                      Icons.self_improvement,
                      color: widget.category.accentColor,
                      size: 24,
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exerciseName,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '60 seconds',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${index + 1}',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: widget.category.accentColor.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoonSection(TherapyCategory category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: category.accentColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: category.accentColor.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: category.accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.fitness_center,
                color: category.accentColor,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Exercises Coming Soon',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We\'re preparing targeted therapeutic exercises\nfor ${category.title.toLowerCase()} relief. Stay tuned!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
