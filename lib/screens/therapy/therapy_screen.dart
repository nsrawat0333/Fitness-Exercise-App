import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'therapy_detail_screen.dart';

/// Data model for a therapy category.
class TherapyCategory {
  final String title;
  final IconData icon;
  final String tagline;
  final List<String> exercises;

  const TherapyCategory({
    required this.title,
    required this.icon,
    required this.tagline,
    required this.exercises,
  });
}

/// All therapy categories with their exercises.
final List<TherapyCategory> _categories = [
  const TherapyCategory(
    title: 'Neck Pain',
    icon: Icons.accessibility_new,
    tagline: 'Ease the Tension',
    exercises: ['Neck stretch', 'Shoulder rolls', 'Chin tucks', 'Side bends'],
  ),
  const TherapyCategory(
    title: 'Headache',
    icon: Icons.hearing,
    tagline: 'Calm the Storm Within',
    exercises: ['Neck stretch', 'Eye relaxation', 'Breathing exercise', 'Temple massage'],
  ),
  const TherapyCategory(
    title: 'Back Pain',
    icon: Icons.airline_seat_recline_normal,
    tagline: 'Strengthen Your Core',
    exercises: ['Cat-cow stretch', 'Lower back mobility', 'Core support', 'Spinal twist'],
  ),
  const TherapyCategory(
    title: 'Knee Pain',
    icon: Icons.directions_walk,
    tagline: 'Move With Confidence',
    exercises: ['Quad stretch', 'Hamstring stretch', 'Knee circles', 'Leg extensions'],
  ),
  const TherapyCategory(
    title: 'Leg Pain',
    icon: Icons.directions_run,
    tagline: 'Restore Leg Strength',
    exercises: ['Calf raises', 'Ankle rotations', 'Seated leg lift', 'Hip flexor stretch'],
  ),
  const TherapyCategory(
    title: 'Periods Care',
    icon: Icons.spa,
    tagline: 'Care & Comfort',
    exercises: ['Light stretching', 'Lower body relaxation', 'Breathing exercises', 'Gentle yoga poses'],
  ),
];

class TherapyScreen extends StatelessWidget {
  const TherapyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── App Bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text('Therapy', style: AppTextStyles.heading2),
                    const Spacer(),
                    Text(
                      'Restorative Oasis',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Hero Banner ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EBE3),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PREMIUM WELLNESS',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Heal your body,\n',
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                            ),
                            TextSpan(
                              text: 'naturally.',
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: AppColors.primary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Divider accent
                      Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Placeholder image area
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2DDD4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Icon(Icons.self_improvement, size: 80, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Categories Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Categories', style: AppTextStyles.heading2),
                    Text(
                      'EXPLORE ALL',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Category Grid ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  itemCount: _categories.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return _CategoryCard(
                      category: cat,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TherapyDetailScreen(category: cat),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual category card widget.
class _CategoryCard extends StatelessWidget {
  final TherapyCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0EDE7),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(category.icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              category.title,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
