import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../data/yoga_user_data.dart';
import 'yoga_weekly_goal_screen.dart';
import 'yoga_plan_generation_screen.dart';

/// Yoga Onboarding Step 5 – "What's your activity level?"
class YogaActivityScreen extends StatefulWidget {
  const YogaActivityScreen({super.key});

  @override
  State<YogaActivityScreen> createState() => _YogaActivityScreenState();
}

class _YogaActivityScreenState extends State<YogaActivityScreen> {
  String? _selected;

  static const _options = [
    {'title': 'Sedentary', 'subtitle': 'Little or no exercise'},
    {'title': 'Lightly active', 'subtitle': 'Light exercise 1-3 days/week'},
    {'title': 'Moderately active', 'subtitle': 'Moderate exercise 3-5 days/week'},
    {'title': 'Very active', 'subtitle': 'Hard exercise 6-7 days/week'},
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
                  Text(
                    'Step 3 of 5',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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

            // ── Progress Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0DCD4),
                  borderRadius: BorderRadius.circular(3),
                ),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),

            // ── Content ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      "What's your activity level?",
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 28),

                    ...(_options.map((opt) {
                      final title = opt['title'] as String;
                      final subtitle = opt['subtitle'] as String;
                      final isSelected = _selected == title;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: GestureDetector(
                          onTap: () => setState(() => _selected = title),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : const Color(0xFFF0ECE6),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: GoogleFonts.outfit(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected ? Colors.white : AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        subtitle,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? Colors.white : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? Colors.white : const Color(0xFFCCC8C0),
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Icon(Icons.check, color: AppColors.primary, size: 16)
                                      : null,
                                ),
                              ],
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
                        YogaUserData().activityLevel = _selected!;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const YogaWeeklyGoalScreen()));
                      }
                    : null,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _selected != null
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('NEXT', style: GoogleFonts.outfit(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        letterSpacing: 1.0, color: Colors.white,
                      )),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
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
}
