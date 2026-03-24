import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../data/yoga_user_data.dart';
import 'yoga_experience_screen.dart';
import 'yoga_plan_generation_screen.dart';

/// Yoga Onboarding Step 3 – "What are your main goals?"
class YogaGoalScreen extends StatefulWidget {
  final String gender;
  const YogaGoalScreen({super.key, required this.gender});

  @override
  State<YogaGoalScreen> createState() => _YogaGoalScreenState();
}

class _YogaGoalScreenState extends State<YogaGoalScreen> {
  String? _selected;

  static const _options = [
    {'title': 'Improve Flexibility', 'icon': Icons.accessibility_new},
    {'title': 'Reduce Stress', 'icon': Icons.spa},
    {'title': 'Lose Weight', 'icon': Icons.local_fire_department},
    {'title': 'Build Strength', 'icon': Icons.fitness_center},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 160,
                    height: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0DCD4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.42,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const YogaPlanGenerationScreen())),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'What are your main goals?',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll tailor your yoga journey to meet your goal.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // Goal cards
                    ...(_options.map((opt) {
                      final title = opt['title'] as String;
                      final icon = opt['icon'] as IconData;
                      final isSelected = _selected == title;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: GestureDetector(
                          onTap: () => setState(() => _selected = title),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: !isSelected
                                  ? Border.all(color: const Color(0xFFE8E4DD), width: 1)
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white.withValues(alpha: 0.2)
                                          : AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(icon, size: 22,
                                        color: isSelected ? Colors.white : AppColors.primary),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? Colors.white : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.primary, width: 2),
                                      ),
                                      child: Icon(Icons.check, color: AppColors.primary, size: 16),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
                  ],
                ),
              ),
            ),

            // ── Bottom Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: GestureDetector(
                onTap: _selected != null
                    ? () {
                        YogaUserData().goal = _selected!;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const YogaExperienceScreen()));
                      }
                    : null,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _selected != null
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Center(
                    child: Text('NEXT', style: GoogleFonts.outfit(
                      fontSize: 17, fontWeight: FontWeight.w700,
                      letterSpacing: 1.0, color: Colors.white,
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
