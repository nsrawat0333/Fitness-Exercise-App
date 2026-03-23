import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import 'gym_pushups_screen.dart';

/// Gym Onboarding Step 1 – "What are your main goals?"
/// Shows gender-specific images on goal cards.
class GymMotivationScreen extends StatefulWidget {
  final String gender; // 'male' or 'female'
  const GymMotivationScreen({super.key, required this.gender});

  @override
  State<GymMotivationScreen> createState() => _GymMotivationScreenState();
}

class _GymMotivationScreenState extends State<GymMotivationScreen> {
  String? _selected;

  List<Map<String, String>> get _options {
    if (widget.gender == 'male') {
      return [
        {'title': 'Lose Weight', 'image': 'assets/images/gym/goal_lose_weight_male.png'},
        {'title': 'Build Muscle', 'image': 'assets/images/gym/goal_build_muscle_male.png'},
        {'title': 'Keep Fit', 'image': 'assets/images/gym/goal_keep_fit_male.png'},
      ];
    } else {
      return [
        {'title': 'Lose Weight', 'image': 'assets/images/gym/goal_lose_weight_female.png'},
        {'title': 'Build Muscle', 'image': 'assets/images/gym/goal_build_muscle_female.png'},
        {'title': 'Get toned', 'image': 'assets/images/gym/goal_get_toned_female.png'},
      ];
    }
  }

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
                  // Progress bar inline
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
                        widthFactor: 0.2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6), // blue progress
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
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
                    const SizedBox(height: 28),

                    // Goal cards
                    ...(_options.map((opt) {
                      final title = opt['title']!;
                      final image = opt['image']!;
                      final isSelected = _selected == title;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () => setState(() => _selected = title),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : Colors.white,
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
                            child: Stack(
                              children: [
                                // Image on the right side
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  width: 140,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    child: Image.asset(
                                      image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Title on the left
                                Positioned(
                                  left: 24,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: Text(
                                      title,
                                      style: GoogleFonts.outfit(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? Colors.white : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                // Check icon when selected
                                if (isSelected)
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0xFF3B82F6), width: 2),
                                      ),
                                      child: const Icon(Icons.check, color: Color(0xFF3B82F6), size: 16),
                                    ),
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
                    ? () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const GymPushupsScreen()))
                    : null,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _selected != null
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF3B82F6).withValues(alpha: 0.4),
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
