import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../data/gym_user_data.dart';
import 'gym_motivation_screen.dart';
import 'gym_plan_generation_screen.dart';

/// Body part option model.
class _BodyPartOption {
  final String title;
  final String subtitle;
  final IconData icon;
  /// Relative position of the dot on the body silhouette (0..1 range).
  final Offset dotPosition;

  const _BodyPartOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.dotPosition,
  });
}

/// Gym Screen 3 – Body Focus / "What's your main focus?"
class GymBodyFocusScreen extends StatefulWidget {
  final String gender; // 'male' or 'female'

  const GymBodyFocusScreen({super.key, required this.gender});

  @override
  State<GymBodyFocusScreen> createState() => _GymBodyFocusScreenState();
}

class _GymBodyFocusScreenState extends State<GymBodyFocusScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedPart;
  late AnimationController _pulseController;

  // Female body parts — positions calibrated to body_female.png
  // (line-art silhouette: head ~13%, shoulders ~22%, torso ~40%, hips ~53%, knees ~75%)
  static const _femaleParts = [
    _BodyPartOption(
      title: 'Full Body',
      subtitle: 'OVERALL TONE',
      icon: Icons.accessibility_new,
      dotPosition: Offset(0.50, 0.10),
    ),
    _BodyPartOption(
      title: 'Chest',
      subtitle: 'UPPER BODY',
      icon: Icons.favorite,
      dotPosition: Offset(0.50, 0.20),
    ),
    _BodyPartOption(
      title: 'Back',
      subtitle: 'POSTURE & STRENGTH',
      icon: Icons.airline_seat_flat,
      dotPosition: Offset(0.50, 0.28),
    ),
    _BodyPartOption(
      title: 'Shoulders',
      subtitle: 'DEFINITION',
      icon: Icons.expand,
      dotPosition: Offset(0.50, 0.22),
    ),
    _BodyPartOption(
      title: 'Biceps',
      subtitle: 'ARM STRENGTH',
      icon: Icons.fitness_center,
      dotPosition: Offset(0.50, 0.30),
    ),
    _BodyPartOption(
      title: 'Triceps',
      subtitle: 'ARM DEFINITION',
      icon: Icons.sports_gymnastics,
      dotPosition: Offset(0.50, 0.32),
    ),
    _BodyPartOption(
      title: 'Abs',
      subtitle: 'CORE STABILITY',
      icon: Icons.grid_view,
      dotPosition: Offset(0.50, 0.42),
    ),
    _BodyPartOption(
      title: 'Glutes',
      subtitle: 'GLUTE SHAPING',
      icon: Icons.directions_walk,
      dotPosition: Offset(0.50, 0.53),
    ),
    _BodyPartOption(
      title: 'Legs',
      subtitle: 'LOWER POWER',
      icon: Icons.directions_run,
      dotPosition: Offset(0.50, 0.72),
    ),
  ];

  // Male body parts — positions calibrated to gender_male.png
  // (cartoon illustration: head ~12%, shoulders ~26%, chest ~35%, waist ~46%, knees ~72%)
  static const _maleParts = [
    _BodyPartOption(
      title: 'Full Body',
      subtitle: 'OVERALL TONE',
      icon: Icons.accessibility_new,
      dotPosition: Offset(0.50, 0.10),
    ),
    _BodyPartOption(
      title: 'Chest',
      subtitle: 'UPPER POWER',
      icon: Icons.favorite,
      dotPosition: Offset(0.50, 0.28),
    ),
    _BodyPartOption(
      title: 'Back',
      subtitle: 'POSTURE & STRENGTH',
      icon: Icons.airline_seat_flat,
      dotPosition: Offset(0.50, 0.32),
    ),
    _BodyPartOption(
      title: 'Shoulders',
      subtitle: 'BROAD & DEFINED',
      icon: Icons.expand,
      dotPosition: Offset(0.50, 0.22),
    ),
    _BodyPartOption(
      title: 'Biceps',
      subtitle: 'ARM STRENGTH',
      icon: Icons.fitness_center,
      dotPosition: Offset(0.50, 0.30),
    ),
    _BodyPartOption(
      title: 'Triceps',
      subtitle: 'ARM DEFINITION',
      icon: Icons.sports_gymnastics,
      dotPosition: Offset(0.50, 0.33),
    ),
    _BodyPartOption(
      title: 'Abs',
      subtitle: 'CORE STABILITY',
      icon: Icons.grid_view,
      dotPosition: Offset(0.50, 0.42),
    ),
    _BodyPartOption(
      title: 'Legs',
      subtitle: 'LOWER POWER',
      icon: Icons.directions_run,
      dotPosition: Offset(0.50, 0.68),
    ),
    _BodyPartOption(
      title: 'Glutes',
      subtitle: 'HIP & GLUTE',
      icon: Icons.directions_walk,
      dotPosition: Offset(0.50, 0.55),
    ),
  ];

  List<_BodyPartOption> get _parts =>
      widget.gender == 'male' ? _maleParts : _femaleParts;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMale = widget.gender == 'male';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EC),
      body: SafeArea(
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
                  const SizedBox(width: 12),
                  // Progress bar
                  Expanded(
                    child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0DCD4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isMale ? 'Your Journey' : 'Your Journey',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      // Skip action
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const GymPlanGenerationScreen()));
                    },
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

            // ── Scrollable Content ──
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: isMale ? _buildMaleLayout() : _buildFemaleLayout(),
                ),
              ),
            ),

            // ── Bottom Bar (Back + Next Step) ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 22),
                        const SizedBox(height: 2),
                        Text(
                          'BACK',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Next Step button
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectedPart != null
                          ? () {
                              GymUserData().focusArea = _selectedPart!;
                              Navigator.push(context,
                                MaterialPageRoute(builder: (_) => GymMotivationScreen(gender: widget.gender)));
                            }
                          : null,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: _selectedPart != null
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'NEXT STEP',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: Colors.white,
                              ),
                            ),
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

  // ═══════════════════════════════════════════════════════════════
  // FEMALE LAYOUT — side-by-side cards + body silhouette with dots
  // ═══════════════════════════════════════════════════════════════
  Widget _buildFemaleLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Title
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "What's\nyour\n",
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
              TextSpan(
                text: 'main\nfocus?',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select a target area\nto customize your\nplan',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
        ),

        const SizedBox(height: 20),

        // Side-by-side: Options list + Body image with dots
        SizedBox(
          height: 720,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: option cards
              Expanded(
                flex: 5,
                child: Column(
                  children: _parts.map((part) {
                    final isSelected = _selectedPart == part.title;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPart = part.title),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withValues(alpha: 0.12) : const Color(0xFFF0ECE6),
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? Border.all(color: AppColors.primary, width: 2)
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.2)
                                      : const Color(0xFFE4E0D8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(part.icon, size: 18, color: AppColors.primary),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      part.title,
                                      style: GoogleFonts.outfit(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      part.subtitle,
                                      style: GoogleFonts.outfit(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(width: 8),

              // Right: Body silhouette with tappable dots
              Expanded(
                flex: 4,
                child: _buildBodySilhouette(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // MALE LAYOUT — stacked option list + body image below
  // ═══════════════════════════════════════════════════════════════
  Widget _buildMaleLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // Title
        Text(
          'Focus Area',
          style: GoogleFonts.outfit(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Select the primary muscle group you'd like to develop.",
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
        ),

        const SizedBox(height: 20),

        // Option cards (stacked)
        ...(_parts.map((part) {
          final isSelected = _selectedPart == part.title;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPart = part.title),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? null
                      : Border.all(color: const Color(0xFFE8E4DD), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : const Color(0xFFF5F2ED),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(part.icon, size: 20,
                        color: isSelected ? Colors.white : AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            part.title,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          if (isSelected)
                            Text(
                              'ACTIVE SELECTION',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                                color: Colors.white70,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: AppColors.primary, size: 16),
                      ),
                  ],
                ),
              ),
            ),
          );
        })),

        const SizedBox(height: 16),

        // Body image with dots — tall enough to show full body
        SizedBox(
          height: 450,
          child: _buildBodySilhouette(),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BODY SILHOUETTE with tappable, pulsing dots
  // ═══════════════════════════════════════════════════════════════
  Widget _buildBodySilhouette() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8E4DD),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              // Body silhouette — fill vertically, clip horizontal edges
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    widget.gender == 'male' 
                        ? 'assets/images/gym/gender_male.png'
                        : 'assets/images/gym/body_female.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Tappable body dots
              ..._parts.map((part) {
                final isSelected = _selectedPart == part.title;
                final left = part.dotPosition.dx * w;
                final top = part.dotPosition.dy * h;

                return Positioned(
                  left: left - 24, // larger hitbox offset
                  top: top - 24,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPart = part.title),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        isSelected: isSelected,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white.withValues(alpha: 0.8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryLight
                                  : const Color(0xFFCCC8C0),
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 14)
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

/// Animated wrapper that provides a subtle pulse when selected.
class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final bool isSelected;
  final Widget child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.isSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSelected) return child;

    return AnimatedBuilder2(
      animation: animation,
      child: child,
    );
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget child;

  const AnimatedBuilder2({
    super.key,
    required Animation<double> animation,
    required this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final anim = listenable as Animation<double>;
    final scale = 1.0 + (anim.value * 0.15);

    return Transform.scale(
      scale: scale,
      child: child,
    );
  }
}
