import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Custom app bar widget matching the FitFi design.
/// Shows leaf icon + "FitFi" branding on left, bell + avatar on right.
class FitfiAppBar extends StatelessWidget {
  const FitfiAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Left: Logo ──
          Row(
            children: [
              Icon(Icons.eco, color: AppColors.primary, size: 28),
              const SizedBox(width: 8),
              Text(
                'FitFi',
                style: AppTextStyles.heading2.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          // ── Right: Bell + Avatar ──
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.notificationBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textOnDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.avatarBorder, width: 2),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE8C8A0), Color(0xFFD4A574)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
