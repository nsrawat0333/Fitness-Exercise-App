import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class GamificationOverlay {
  /// Shows a "+[points] XP" floating animation over the current screen
  static void showPointsEarned(BuildContext context, int points) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.3,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Using a built-in icon since explicit Lottie JSON may be missing
                      // Can swap with Lottie.asset('assets/images/jsonanimation/confetti.json') if available
                      const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 100),
                      const SizedBox(height: 16),
                      Text(
                        '+$points XP',
                        style: GoogleFonts.outfit(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF5B7E5F),
                          shadows: [
                            const Shadow(
                              offset: Offset(0, 4),
                              blurRadius: 10.0,
                              color: Colors.black26,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Workout Completed!',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);

    // Remove the overlay after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
