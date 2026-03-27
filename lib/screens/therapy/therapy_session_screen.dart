import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../data/hindi_exercise_instructions.dart';
import '../../services/voice_coach_service.dart';
import '../../services/music_service.dart';
import '../../widgets/voice_toggle_button.dart';
import '../../widgets/music_toggle_button.dart';

class TherapySessionScreen extends StatefulWidget {
  final String categoryTitle;
  final int duration;
  final String sessionLabel;
  final List<String> exercises;

  const TherapySessionScreen({
    super.key,
    required this.categoryTitle,
    required this.duration,
    required this.sessionLabel,
    required this.exercises,
  });

  @override
  State<TherapySessionScreen> createState() => _TherapySessionScreenState();
}

class _TherapySessionScreenState extends State<TherapySessionScreen> {
  final VoiceCoachService _voiceCoach = VoiceCoachService();
  final MusicService _musicService = MusicService();

  @override
  void initState() {
    super.initState();
    _voiceCoach.init();
    _musicService.init();
    _speakTherapyInstructions();
    _musicService.setVolume(0.2);
    _musicService.play();
  }

  @override
  void dispose() {
    _voiceCoach.stop();
    _musicService.stop();
    super.dispose();
  }

  void _speakTherapyInstructions() {
    final key = widget.categoryTitle.toLowerCase();
    final data = HindiExerciseInstructions.getInstructions(key);
    if (data != null) {
      _voiceCoach.speakSequence(data.start);
      _voiceCoach.speakSequence(data.posture);
      _voiceCoach.speakSequence(data.breathing);
    } else {
      // Fallback generic therapy guidance
      _voiceCoach.speakSequence([
        'थेरेपी सेशन शुरू हो रहा है।',
        'आराम से करें, कोई झटका न दें।',
        'धीरे और नियंत्रित मूवमेंट रखें।',
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF2F5EC),
              Color(0xFFE4EBD8),
              Color(0xFFD6E2C8),
            ],
          ),
        ),
        child: SafeArea(
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
                    const Spacer(),
                    const VoiceToggleButton(),
                    const SizedBox(width: 6),
                    const MusicToggleButton(),
                    const SizedBox(width: 12),
                    const Icon(Icons.more_horiz, color: AppColors.textPrimary, size: 24),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // ── Session Title ──
              Text(
                'Starting your therapy\nsession…',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),

              const Spacer(),

              // ── Central Leaf Icon ──
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    child: Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.eco, color: AppColors.primary, size: 36),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── Breathe In / Session Info ──
              Text(
                'BREATHE IN',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3.0,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              // Progress bar placeholder
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const Spacer(),

              // ── Session Details Card ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${widget.categoryTitle} – ${widget.sessionLabel}',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.duration} min session  •  ${widget.exercises.length} exercises',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFE0DCD4)),
                      const SizedBox(height: 12),
                      // Exercise list preview
                      ...widget.exercises.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              e,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Branding ──
              Text(
                'Restorative Oasis',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
