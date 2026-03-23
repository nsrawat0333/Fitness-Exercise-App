import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'therapy_screen.dart';
import 'therapy_session_screen.dart';

/// Duration option model.
class _DurationOption {
  final int minutes;
  final String label;
  final bool isRecommended;

  const _DurationOption({
    required this.minutes,
    required this.label,
    this.isRecommended = false,
  });
}

class TherapyDetailScreen extends StatefulWidget {
  final TherapyCategory category;

  const TherapyDetailScreen({super.key, required this.category});

  @override
  State<TherapyDetailScreen> createState() => _TherapyDetailScreenState();
}

class _TherapyDetailScreenState extends State<TherapyDetailScreen> {
  int _selectedDuration = 30;

  late final List<_DurationOption> _durations;

  /// Map category to duration sub-labels
  List<_DurationOption> _buildDurations() {
    switch (widget.category.title) {
      case 'Back Pain':
        return const [
          _DurationOption(minutes: 15, label: 'Release'),
          _DurationOption(minutes: 30, label: 'Align', isRecommended: true),
          _DurationOption(minutes: 60, label: 'Strengthen'),
        ];
      case 'Headache':
        return const [
          _DurationOption(minutes: 15, label: 'Relax'),
          _DurationOption(minutes: 30, label: 'Relief', isRecommended: true),
          _DurationOption(minutes: 60, label: 'Recovery'),
        ];
      case 'Periods Care':
        return const [
          _DurationOption(minutes: 15, label: 'Gentle'),
          _DurationOption(minutes: 30, label: 'Comfort', isRecommended: true),
          _DurationOption(minutes: 60, label: 'Restorative'),
        ];
      default:
        return const [
          _DurationOption(minutes: 15, label: 'Quick'),
          _DurationOption(minutes: 30, label: 'Standard', isRecommended: true),
          _DurationOption(minutes: 60, label: 'Deep'),
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    _durations = _buildDurations();
  }

  String get _sessionLabel {
    final d = _durations.firstWhere((d) => d.minutes == _selectedDuration);
    return d.label;
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${category.title} Relief',
                        style: AppTextStyles.heading3,
                      ),
                    ),
                  ),
                  const Icon(Icons.favorite_border, color: AppColors.textPrimary, size: 24),
                ],
              ),
            ),

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Hero Banner ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFE0D5C8), Color(0xFFBFB5A5)],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Stack(
                          children: [
                            // Placeholder therapy image
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  color: const Color(0xFFD5CCBF),
                                  child: Center(
                                    child: Icon(
                                      category.icon,
                                      size: 80,
                                      color: Colors.white.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Overlay text
                            Positioned(
                              left: 24,
                              bottom: 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'THERAPY CATEGORY',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2.0,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    category.tagline,
                                    style: GoogleFonts.outfit(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Choose Duration ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Choose Duration', style: AppTextStyles.heading3),
                          Text(
                            '${_durations.length} sessions available',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Duration Cards ──
                    ...List.generate(_durations.length, (i) {
                      final opt = _durations[i];
                      final isSelected = _selectedDuration == opt.minutes;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedDuration = opt.minutes),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: isSelected
                                  ? null
                                  : Border.all(color: const Color(0xFFE8E4DD), width: 1),
                            ),
                            child: Row(
                              children: [
                                // Duration icon
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : const Color(0xFFF5F2ED),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.timer,
                                    color: isSelected ? Colors.white : AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Label
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${opt.minutes} min',
                                      style: GoogleFonts.outfit(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? Colors.white : AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      opt.label.toUpperCase(),
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0,
                                        color: isSelected
                                            ? Colors.white70
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                // Badge or Arrow
                                if (opt.isRecommended && isSelected)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'RECOMMENDED',
                                          style: GoogleFonts.outfit(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.check_circle, color: Colors.white, size: 14),
                                      ],
                                    ),
                                  )
                                else if (!isSelected)
                                  const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 28),

                    // ── Exercise List ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '$_sessionLabel Exercises',
                        style: AppTextStyles.heading3,
                      ),
                    ),

                    const SizedBox(height: 16),

                    ...List.generate(category.exercises.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFEDE9E2), width: 1),
                          ),
                          child: Row(
                            children: [
                              // Placeholder avatar
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0ECE6),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.self_improvement,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  category.exercises[i],
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0ECE6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow, color: AppColors.textPrimary, size: 18),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Bottom Start Button ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TherapySessionScreen(
                        categoryTitle: category.title,
                        duration: _selectedDuration,
                        sessionLabel: _sessionLabel,
                        exercises: category.exercises,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_circle_filled, color: Colors.white, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        'Start ${_selectedDuration}min Therapy Session',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
