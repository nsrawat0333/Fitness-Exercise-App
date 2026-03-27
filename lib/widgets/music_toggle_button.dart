import 'package:flutter/material.dart';
import '../services/music_service.dart';

/// Reusable music toggle button for workout screens.
class MusicToggleButton extends StatelessWidget {
  const MusicToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: MusicService().enabledNotifier,
      builder: (context, enabled, _) {
        return GestureDetector(
          onTap: () {
            final svc = MusicService();
            if (enabled) {
              svc.setEnabled(false);
            } else {
              svc.setEnabled(true);
              svc.play();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: enabled
                  ? const Color(0xFFFF6B6B).withValues(alpha: 0.12)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: enabled
                    ? const Color(0xFFFF6B6B).withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(
              enabled ? Icons.music_note_rounded : Icons.music_off_rounded,
              color: enabled ? const Color(0xFFFF6B6B) : Colors.grey,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}
