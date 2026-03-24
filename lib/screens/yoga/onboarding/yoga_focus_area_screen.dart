import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../data/yoga_user_data.dart';
import 'yoga_goal_screen.dart';
import 'yoga_plan_generation_screen.dart';

/// Yoga Onboarding Step 2 – "What's your main focus?"
/// Yoga-specific focus areas instead of gym body parts.
class YogaFocusAreaScreen extends StatefulWidget {
  final String gender;
  const YogaFocusAreaScreen({super.key, required this.gender});

  @override
  State<YogaFocusAreaScreen> createState() => _YogaFocusAreaScreenState();
}

class _YogaFocusAreaScreenState extends State<YogaFocusAreaScreen> {
  String? _selected;

  static const _focusOptions = [
    {'title': 'Flexibility', 'subtitle': 'IMPROVE RANGE OF MOTION', 'icon': Icons.accessibility_new},
    {'title': 'Stress Relief', 'subtitle': 'CALM MIND & RELAX', 'icon': Icons.spa},
    {'title': 'Weight Loss', 'subtitle': 'BURN FAT & TONE', 'icon': Icons.local_fire_department},
    {'title': 'Core & Strength', 'subtitle': 'BUILD INNER POWER', 'icon': Icons.fitness_center},
    {'title': 'Back Pain Relief', 'subtitle': 'HEAL & STRENGTHEN', 'icon': Icons.healing},
    {'title': 'Full Body', 'subtitle': 'COMPLETE WELLNESS', 'icon': Icons.self_improvement},
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: AppColors.textPrimary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0DCD4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.28,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Your Journey',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
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

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "What's your\n",
                              style: GoogleFonts.outfit(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                height: 1.15,
                              ),
                            ),
                            TextSpan(
                              text: 'main focus?',
                              style: GoogleFonts.outfit(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select a yoga focus to customize your plan',
                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
                      ),
                      const SizedBox(height: 24),

                      // Focus cards
                      ..._focusOptions.map((opt) {
                        final title = opt['title'] as String;
                        final subtitle = opt['subtitle'] as String;
                        final icon = opt['icon'] as IconData;
                        final isSelected = _selected == title;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => setState(() => _selected = title),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: isSelected
                                    ? null
                                    : Border.all(color: const Color(0xFFE8E4DD), width: 1),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white.withValues(alpha: 0.2)
                                          : const Color(0xFFF5F2ED),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(icon, size: 22,
                                        color: isSelected ? Colors.white : AppColors.primary),
                                  ),
                                  const SizedBox(width: 14),
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
                                          style: GoogleFonts.outfit(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                            color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.check, color: AppColors.primary, size: 16),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom Bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 22),
                        const SizedBox(height: 2),
                        Text(
                          'BACK',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _selected != null
                          ? () {
                              YogaUserData().focusArea = _selected!;
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => YogaGoalScreen(gender: widget.gender)));
                            }
                          : null,
                      child: Container(
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
                            Text(
                              'NEXT STEP',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: Colors.white,
                              ),
                            ),
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
          ],
        ),
      ),
    );
  }
}
