import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'yoga_30day_screen.dart';
import 'yoga_focus_screen.dart';
import 'yoga_diet_screen.dart';
import 'yoga_custom_plan_screen.dart';

class YogaHomeScreen extends StatelessWidget {
  const YogaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: AppColors.textPrimary, size: 24),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('Yoga Studio',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                    ),
                  ),
                  const SizedBox(width: 24), // Balance spacing
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Top Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5B7E5F), Color(0xFF729B79)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5B7E5F).withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Your\nYoga Journey',
                                style: GoogleFonts.outfit(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Find balance, flexibility, and strength.',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.self_improvement,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Cards Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      _buildMenuCard(
                        context,
                        title: '30 Days\nProgram',
                        subtitle: 'Progressive plan',
                        icon: Icons.calendar_today_rounded,
                        color: const Color(0xFFD4A574),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Yoga30DayScreen()),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        title: 'Focus\nAreas',
                        subtitle: 'Targeted sessions',
                        icon: Icons.track_changes_rounded,
                        color: const Color(0xFF5EC6C6),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const YogaFocusScreen()),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        title: 'Diet\nPlans',
                        subtitle: 'Yoga friendly',
                        icon: Icons.restaurant_menu_rounded,
                        color: const Color(0xFFE57373),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const YogaDietScreen()),
                        ),
                      ),
                      _buildMenuCard(
                        context,
                        title: 'Custom\nPlan',
                        subtitle: 'Smart generator',
                        icon: Icons.tune_rounded,
                        color: const Color(0xFF7C4DFF),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const YogaCustomPlanScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
