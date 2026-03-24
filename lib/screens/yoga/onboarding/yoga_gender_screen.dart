import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../data/yoga_user_data.dart';
import 'yoga_focus_area_screen.dart';

/// Yoga Onboarding Step 1 – Gender Selection.
class YogaGenderScreen extends StatefulWidget {
  const YogaGenderScreen({super.key});

  @override
  State<YogaGenderScreen> createState() => _YogaGenderScreenState();
}

class _YogaGenderScreenState extends State<YogaGenderScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ── Top Bar (Back + Progress Dots) ──
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _buildDot(true),
                      const SizedBox(width: 6),
                      _buildDot(false),
                      const SizedBox(width: 6),
                      _buildDot(false),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(width: 24),
                ],
              ),

              const SizedBox(height: 32),

              // ── Title ──
              Text(
                "What's your gender?",
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Let us know you better to personalize your yoga plan.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // ── Male Card ──
              GestureDetector(
                onTap: () => setState(() => _selected = 'male'),
                child: _GenderCard(
                  label: 'Male',
                  imagePath: 'assets/images/gym/gender_male.png',
                  isSelected: _selected == 'male',
                  bgColor: const Color(0xFFD0CCC6),
                  selectedBgColor: const Color(0xFF3A4A3A),
                ),
              ),
              const SizedBox(height: 16),

              // ── Female Card ──
              GestureDetector(
                onTap: () => setState(() => _selected = 'female'),
                child: _GenderCard(
                  label: 'Female',
                  imagePath: 'assets/images/gym/gender_female.png',
                  isSelected: _selected == 'female',
                  bgColor: const Color(0xFFD0CCC6),
                  selectedBgColor: const Color(0xFF3A4A3A),
                ),
              ),

              const Spacer(),

              // ── Next Step ──
              GestureDetector(
                onTap: () {
                  YogaUserData().gender = _selected ?? 'female';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => YogaFocusAreaScreen(gender: _selected ?? 'female'),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B7E5F), Color(0xFF4A6B4E)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next Step',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () {
                    YogaUserData().gender = _selected ?? 'female';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => YogaFocusAreaScreen(gender: _selected ?? 'female'),
                      ),
                    );
                  },
                  child: Text(
                    "I'D RATHER NOT SAY",
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: isActive ? 32 : 10,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : const Color(0xFFD8D4CD),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final Color bgColor;
  final Color selectedBgColor;

  const _GenderCard({
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.bgColor,
    required this.selectedBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: isSelected ? selectedBgColor : bgColor,
        borderRadius: BorderRadius.circular(24),
        border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: isSelected ? null : 24,
            bottom: isSelected ? 24 : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'SELECTED',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.check_circle, color: AppColors.primaryLight, size: 14),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            right: 20,
            top: 10,
            bottom: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(imagePath, width: 140, fit: BoxFit.cover),
            ),
          ),
          if (isSelected)
            Positioned(
              right: 16,
              top: 16,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
            ),
        ],
      ),
    );
  }
}
