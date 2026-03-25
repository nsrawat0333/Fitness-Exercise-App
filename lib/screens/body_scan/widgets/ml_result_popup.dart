import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../services/body_scan_service.dart';
import '../body_scan_result_screen.dart';

class MLResultPopup extends StatelessWidget {
  final BodyScanResult result;
  final File? imageFile;

  const MLResultPopup({
    super.key,
    required this.result,
    this.imageFile,
  });

  String _getPopupTitle() {
    switch (result.type) {
      case BodyType.fat:
        return "You're slightly overweight. Let's reduce fat 🔥";
      case BodyType.lean:
        return "You're lean! Let's build strength 💪";
      case BodyType.fit:
      default:
        return "You're in great shape! Keep going 🚀";
    }
  }

  Color _getBadgeColor() {
    switch (result.type) {
      case BodyType.fat:
        return const Color(0xFFE63946);
      case BodyType.lean:
        return const Color(0xFF2ECC71);
      case BodyType.fit:
      default:
        return const Color(0xFF3A86FF);
    }
  }

  String _getBadgeText() {
    switch (result.type) {
      case BodyType.fat: return "ENDOMORPH";
      case BodyType.lean: return "ECTOMORPH";
      case BodyType.fit:
      default: return "MESOMORPH";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ML Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getBadgeColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, color: _getBadgeColor(), size: 16),
                  const SizedBox(width: 8),
                  Text(
                    _getBadgeText(),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _getBadgeColor(),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Animated message
            Text(
              _getPopupTitle(),
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              "AI Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%",
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            // CTA
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BodyScanResultScreen(
                      result: result,
                      imageFile: imageFile,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                ),
                child: Center(
                  child: Text(
                    'Generate Full Plan',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
