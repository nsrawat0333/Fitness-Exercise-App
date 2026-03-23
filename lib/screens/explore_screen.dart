import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'gym/gym_welcome_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    const Icon(Icons.menu, color: AppColors.textPrimary, size: 24),
                    const Spacer(),
                    Text(
                      'Explore',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    // Profile avatar
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE0D5C8),
                        border: Border.all(color: AppColors.avatarBorder, width: 2),
                      ),
                      child: const Icon(Icons.person, color: AppColors.textSecondary, size: 18),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ── Search Bar ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EDE7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.search, color: AppColors.textMuted, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Search experiences...',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Yoga Flow Card ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ExploreCard(
                  tag: 'RESTORATIVE',
                  tagColor: const Color(0xFFD4A574),
                  title: 'Yoga Flow',
                  gradientColors: const [Color(0xFFD4DEC4), Color(0xFFB8CCAA)],
                  icon: Icons.self_improvement,
                  onTap: () {
                    // TODO: Navigate to Yoga section screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Yoga section coming soon...')),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── Workout Programs Card ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ExploreCard(
                  tag: 'PERFORMANCE',
                  tagColor: const Color(0xFFD4A574),
                  title: 'Workout\nPrograms',
                  gradientColors: const [Color(0xFFD5CCC0), Color(0xFFB8AFA3)],
                  icon: Icons.fitness_center,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GymWelcomeScreen()),
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

/// Reusable large explore card widget.
class _ExploreCard extends StatelessWidget {
  final String tag;
  final Color tagColor;
  final String title;
  final List<Color> gradientColors;
  final IconData icon;
  final VoidCallback onTap;

  const _ExploreCard({
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.gradientColors,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 280,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          children: [
            // Central icon (placeholder for image)
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 72,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),

            // Tag badge
            Positioned(
              left: 24,
              bottom: 80,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Title
            Positioned(
              left: 24,
              bottom: 24,
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
