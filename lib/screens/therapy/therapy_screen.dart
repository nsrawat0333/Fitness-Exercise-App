import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import 'therapy_detail_screen.dart';
import 'therapy_custom_exercise_screen.dart';

/// Data model for a therapy category.
class TherapyCategory {
  final String title;
  final IconData icon;
  final String tagline;
  final List<String> exercises;
  final String? imagePath;
  final Color accentColor;
  final String? animationFolderPath;

  const TherapyCategory({
    required this.title,
    required this.icon,
    required this.tagline,
    required this.exercises,
    this.imagePath,
    this.accentColor = const Color(0xFF5B7E5F),
    this.animationFolderPath,
  });
}

/// Exercise entry linking name to its animation folder.
class TherapyExerciseEntry {
  final String name;
  final String animationFolderPath;

  const TherapyExerciseEntry({
    required this.name,
    required this.animationFolderPath,
  });

  String get animationPath => '$animationFolderPath$name.json';
}

/// Master list of ALL therapy exercises (for the custom exercise builder).
List<TherapyExerciseEntry> get allTherapyExercises {
  final List<TherapyExerciseEntry> all = [];
  final seen = <String>{};
  for (final cat in therapyCategories) {
    if (cat.animationFolderPath == null) continue;
    for (final ex in cat.exercises) {
      final key = '${cat.animationFolderPath}$ex';
      if (!seen.contains(key)) {
        seen.add(key);
        all.add(TherapyExerciseEntry(
          name: ex,
          animationFolderPath: cat.animationFolderPath!,
        ));
      }
    }
  }
  return all;
}

/// ── All therapy categories ──
final List<TherapyCategory> therapyCategories = [
  // ── Pain Relief ──
  const TherapyCategory(
    title: 'Headache',
    icon: Icons.psychology,
    tagline: 'Calm the Storm Within',
    exercises: [
      'Deep Breathing',
      'Neck Stretch',
      'Child\u2019s Pose',
      'Cat-Cow Stretch',
      'Forward Bend Stretch',
      'Neck Rotation',
      'Temple Massage',
      'Forehead Massage',
      'Scalp Massage',
      'Jaw Relaxation Exercise',
    ],
    imagePath: 'assets/images/therapy/therapy_headache.png',
    accentColor: Color(0xFF5EC6C6),
    animationFolderPath: 'assets/images/therepy/jsonanimationheadeche/',
  ),
  const TherapyCategory(
    title: 'Neck Pain',
    icon: Icons.accessibility_new,
    tagline: 'Ease the Tension',
    exercises: [
      'Neck Stretch',
      'Neck Flexion',
      'Neck Extension',
      'Neck Rotation',
      'Chin Tuck Exercise',
      'Shoulder Rolls',
      'Cat-Cow Stretch2',
      'Upper Trapezius Stretch',
      'Neck Self Massage',
    ],
    imagePath: 'assets/images/therapy/therapy_neck_pain.png',
    accentColor: Color(0xFF5B7E5F),
    animationFolderPath: 'assets/images/therepy/jsonanimationneckpain/',
  ),
  const TherapyCategory(
    title: 'Back Pain',
    icon: Icons.airline_seat_recline_normal,
    tagline: 'Strengthen Your Core',
    exercises: [
      'Bird Dog Exercise',
      'Cat-Cow Stretch2',
      'Child\u2019s Pose',
      'Cobra Stretch (1)',
      'Knee to Chest Stretch',
      'Pelvic Tilt',
      'Superman Exercise',
      'Standing Side Stretch',
    ],
    imagePath: 'assets/images/therapy/therapy_back_pain.png',
    accentColor: Color(0xFFD4A574),
    animationFolderPath: 'assets/images/therepy/jsonanimationbackpain/',
  ),
  const TherapyCategory(
    title: 'Stomach Pain',
    icon: Icons.restaurant,
    tagline: 'Soothe & Heal',
    exercises: [
      'Cat-Cow Stretch2 (1)',
      'Cobra Stretch (1)',
      'Deep Breathing (1)',
      'Forward Bend Stretch (1)',
      'Knee to Chest Stretch (1)',
      'boat_pose (1)',
      'child_pose (1)',
      'spinal_twist (1)',
    ],
    accentColor: Color(0xFF7C4DFF),
    animationFolderPath: 'assets/images/therepy/jsonanimationstomackpain/',
  ),
  const TherapyCategory(
    title: 'Knee Pain',
    icon: Icons.directions_walk,
    tagline: 'Move With Confidence',
    exercises: [
      'Box jump',
      'Calf Raises',
      'Glute Bridge',
      'Goblet Squats (1)',
      'Heel Slides',
      'Leg Raises',
      'Seated Knee Extension',
      'Wall Sit',
      'hamstringstrech',
      'jump squats (1)',
    ],
    accentColor: Color(0xFFFF6B6B),
    animationFolderPath: 'assets/images/therepy/jsonanimationkneepain/',
  ),

  // ── Wellness & Care ──
  const TherapyCategory(
    title: 'Periods Care',
    icon: Icons.spa,
    tagline: 'Care & Comfort',
    exercises: [
      'Cat Cow Pose',
      'Cobra Stretch (1)',
      'Deep Breathing (1)',
      'Knee to Chest Stretch (1)',
      'Pelvic Tilt (1)',
      'butterfly_pose (1)',
      'child_pose (1)',
      'legs_up_wall (1)',
      'spinal_twist (1)',
    ],
    accentColor: Color(0xFFE91E8C),
    animationFolderPath: 'assets/images/therepy/jsonanimationperiodscare/',
  ),

  // ── New Course Sections (reuse existing animations) ──
  const TherapyCategory(
    title: 'Shoulder Pain',
    icon: Icons.sports_gymnastics,
    tagline: 'Release & Relax',
    exercises: [
      'Shoulder Rolls',
      'Upper Trapezius Stretch',
      'Neck Stretch',
      'Neck Rotation',
      'Chin Tuck Exercise',
      'Cat-Cow Stretch2',
      'Neck Self Massage',
    ],
    accentColor: Color(0xFF3B82F6),
    animationFolderPath: 'assets/images/therepy/jsonanimationneckpain/',
  ),
  const TherapyCategory(
    title: 'Full Body Relief',
    icon: Icons.self_improvement,
    tagline: 'Total Body Wellness',
    exercises: [
      'Deep Breathing',
      'Neck Stretch',
      'Cat-Cow Stretch',
      'Child\u2019s Pose',
      'Forward Bend Stretch',
    ],
    accentColor: Color(0xFF10B981),
    animationFolderPath: 'assets/images/therepy/jsonanimationheadeche/',
  ),
];

// ── Helper to group categories ──
List<TherapyCategory> get painReliefCategories =>
    therapyCategories.where((c) => [
      'Headache', 'Neck Pain', 'Back Pain', 'Stomach Pain', 'Knee Pain', 'Shoulder Pain',
    ].contains(c.title)).toList();

List<TherapyCategory> get wellnessCategories =>
    therapyCategories.where((c) => [
      'Periods Care', 'Full Body Relief',
    ].contains(c.title)).toList();


// ═══════════════════════════════════════════════════════════
//  Therapy Home Screen — Course-Style Layout
// ═══════════════════════════════════════════════════════════

class TherapyHomeScreen extends StatelessWidget {
  const TherapyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              const SizedBox(height: 16),
              _buildHeroBanner(),
              const SizedBox(height: 28),

              // ── Custom Exercise Card ──
              _buildCustomExerciseCard(context),
              const SizedBox(height: 28),

              // ── Pain Relief Courses ──
              _buildSectionHeader('Pain Relief Courses', '${painReliefCategories.length} COURSES'),
              const SizedBox(height: 14),
              _buildHorizontalCourseList(context, painReliefCategories),
              const SizedBox(height: 28),

              // ── Wellness & Care ──
              _buildSectionHeader('Wellness & Care', '${wellnessCategories.length} COURSES'),
              const SizedBox(height: 14),
              _buildHorizontalCourseList(context, wellnessCategories),
              const SizedBox(height: 28),

              // ── All Courses Grid ──
              _buildSectionHeader('All Courses', '${therapyCategories.length} SECTIONS'),
              const SizedBox(height: 14),
              _buildCategoryGrid(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
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
          Text(
            'THERAPY',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF5B7E5F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Restorative Oasis',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF5B7E5F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          image: const DecorationImage(
            image: AssetImage('assets/images/therapy/therapy_hero.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 24,
              bottom: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B7E5F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PREMIUM WELLNESS',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Heal your body,\nnaturally.',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
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

  // ── Custom Exercise Card ──
  Widget _buildCustomExerciseCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TherapyCustomExerciseScreen()),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.tune, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Exercise',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Build your own therapy session',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section Header ──
  Widget _buildSectionHeader(String title, String badge) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            badge,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: const Color(0xFF5B7E5F),
            ),
          ),
        ],
      ),
    );
  }

  // ── Horizontal Scrolling Course List ──
  Widget _buildHorizontalCourseList(BuildContext context, List<TherapyCategory> categories) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _HorizontalCourseCard(
            category: cat,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TherapyDetailScreen(category: cat)),
              );
            },
          );
        },
      ),
    );
  }

  // ── All Courses Grid ──
  Widget _buildCategoryGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        itemCount: therapyCategories.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final cat = therapyCategories[index];
          return _TherapyCategoryCard(
            category: cat,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TherapyDetailScreen(category: cat)),
              );
            },
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Horizontal Course Card
// ═══════════════════════════════════════════════════════════

class _HorizontalCourseCard extends StatelessWidget {
  final TherapyCategory category;
  final VoidCallback onTap;

  const _HorizontalCourseCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: category.accentColor.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background
              if (category.imagePath != null)
                Image.asset(
                  category.imagePath!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _buildGradientBg(),
                )
              else
                _buildGradientBg(),

              // Dark overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),

              // Icon badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(category.icon, color: Colors.white, size: 18),
                ),
              ),

              // Title + count
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${category.exercises.length} Exercises',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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

  Widget _buildGradientBg() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            category.accentColor,
            category.accentColor.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          category.icon,
          size: 50,
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Grid Category Card (kept from original)
// ═══════════════════════════════════════════════════════════

class _TherapyCategoryCard extends StatelessWidget {
  final TherapyCategory category;
  final VoidCallback onTap;

  const _TherapyCategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: category.accentColor.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (category.imagePath != null)
                Image.asset(
                  category.imagePath!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _buildGradientBg(),
                )
              else
                _buildGradientBg(),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(category.icon, color: Colors.white, size: 20),
                ),
              ),

              Positioned(
                left: 14,
                bottom: 14,
                right: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.tagline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${category.exercises.length} Exercises',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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

  Widget _buildGradientBg() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            category.accentColor,
            category.accentColor.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          category.icon,
          size: 60,
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}
