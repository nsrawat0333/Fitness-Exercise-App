import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import 'gym/gym_welcome_screen.dart';
import 'yoga/onboarding/yoga_welcome_screen.dart';
import 'body_scan/body_scan_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';

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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                      child: const Icon(Icons.settings, color: AppColors.textPrimary, size: 28),
                    ),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE0D5C8),
                          border: Border.all(color: AppColors.avatarBorder, width: 2),
                        ),
                        child: const Icon(Icons.person, color: AppColors.textSecondary, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              const SizedBox(height: 24),

              // ── Workout Programs Card ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ExploreCard(
                  tag: 'PERFORMANCE',
                  tagColor: const Color(0xFFD4A574),
                  title: 'Workout\nPrograms',
                  backgroundAsset: 'assets/images/explore/gym_bodybuilder.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GymWelcomeScreen()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── Yoga Flow Card ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ExploreCard(
                  tag: 'RESTORATIVE',
                  tagColor: const Color(0xFFD4A574),
                  title: 'Yoga Flow',
                  backgroundAsset: 'assets/images/explore/yoga_girl.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const YogaWelcomeScreen()),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── AI Body Scan Card ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ExploreCard(
                  tag: 'AI POWERED',
                  tagColor: AppColors.primary,
                  title: 'AI Body\nScan',
                  backgroundAsset: 'assets/images/explore/gym_bodybuilder.png', // Reusing asset for now
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BodyScanScreen()),
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
  final String backgroundAsset;
  final VoidCallback onTap;

  const _ExploreCard({
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.backgroundAsset,
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
          borderRadius: BorderRadius.circular(28),
          image: DecorationImage(
            image: AssetImage(backgroundAsset),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Dark overlay for readable text
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: Colors.black.withValues(alpha: 0.3),
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
