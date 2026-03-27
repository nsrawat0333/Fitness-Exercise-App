import 'package:flutter/material.dart';
import '../services/voice_coach_service.dart';

/// Reusable voice coaching toggle button.
/// Shows a mic icon that toggles Hindi voice coaching on/off.
class VoiceToggleButton extends StatelessWidget {
  const VoiceToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: VoiceCoachService().enabledNotifier,
      builder: (context, enabled, _) {
        return GestureDetector(
          onTap: () {
            VoiceCoachService().setEnabled(!enabled);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: enabled
                  ? const Color(0xFF5B7E5F).withValues(alpha: 0.12)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: enabled
                    ? const Color(0xFF5B7E5F).withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  enabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  color: enabled ? const Color(0xFF5B7E5F) : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  enabled ? 'हिंदी' : 'म्यूट',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: enabled ? const Color(0xFF5B7E5F) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
