import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import 'gym_activity_screen.dart';

/// Gym Onboarding Step 2 – "How many push-ups can you do at one time?"
class GymPushupsScreen extends StatefulWidget {
  const GymPushupsScreen({super.key});

  @override
  State<GymPushupsScreen> createState() => _GymPushupsScreenState();
}

class _GymPushupsScreenState extends State<GymPushupsScreen> {
  String? _selected;

  static const _options = [
    {'title': 'Beginner', 'subtitle': '3–5 reps'},
    {'title': 'Intermediate', 'subtitle': '5–10 reps'},
    {'title': 'Advanced', 'subtitle': '10+ reps'},
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
                    'Step 2 of 5',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
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
                  widthFactor: 0.4,
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
                      'How many push-ups can you do at one time?',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Options
                    ...(_options.map((opt) {
                      final title = opt['title'] as String;
                      final subtitle = opt['subtitle'] as String;
                      final isSelected = _selected == title;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => setState(() => _selected = title),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
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
                                          fontSize: 18,
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
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? Colors.white : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? Colors.white : const Color(0xFFCCC8C0),
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        )
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

            // ── Bottom Buttons (Back + Next) ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E4DD),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text('BACK', style: GoogleFonts.outfit(
                          fontSize: 14, fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Next button
                  Expanded(
                    child: GestureDetector(
                      onTap: _selected != null
                          ? () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const GymActivityScreen()))
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
          ],
        ),
      ),
    );
  }
}
