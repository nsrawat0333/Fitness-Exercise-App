import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../data/yoga_user_data.dart';
import 'yoga_body_info_screen.dart';
import 'yoga_plan_generation_screen.dart';

/// Yoga Onboarding Step 6 – "Set your weekly goal"
class YogaWeeklyGoalScreen extends StatefulWidget {
  const YogaWeeklyGoalScreen({super.key});

  @override
  State<YogaWeeklyGoalScreen> createState() => _YogaWeeklyGoalScreenState();
}

class _YogaWeeklyGoalScreenState extends State<YogaWeeklyGoalScreen> {
  int _selectedDays = 3;
  String _firstDay = 'SUNDAY';

  static const _dayMessages = {
    1: "A gentle start! Even one day a week builds the habit.",
    2: "Nice balance! Two days is perfect for beginners.",
    3: "Great choice! 3 days a week is ideal for steady growth.",
    4: "Strong commitment! 4 days builds real consistency.",
    5: "Impressive! 5 days shows serious dedication.",
    6: "Wonderful! 6 days a week is a deep practice routine.",
    7: "Full dedication! Daily yoga for ultimate transformation.",
  };

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
                    'Step 4 of 5',
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
                  widthFactor: 0.8,
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        'Set your weekly goal',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Day grid (1–7)
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(7, (i) {
                          final day = i + 1;
                          final isSelected = _selectedDays == day;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedDays = day),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : const Color(0xFFE4E0D8),
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 3)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  '$day',
                                  style: GoogleFonts.outfit(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 24),

                      // Message box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.self_improvement, color: AppColors.primary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _dayMessages[_selectedDays]!,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // First day of week
                      Text(
                        'FIRST DAY OF WEEK',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE8E4DD)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _firstDay,
                            isExpanded: true,
                            isDense: true,
                            icon: const Icon(Icons.unfold_more, color: AppColors.textSecondary),
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            items: ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY']
                                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                                .toList(),
                            onChanged: (v) => setState(() => _firstDay = v!),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom Buttons ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E4DD),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.close, color: AppColors.textPrimary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        YogaUserData().weeklyGoalDays = _selectedDays;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const YogaBodyInfoScreen()));
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
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
