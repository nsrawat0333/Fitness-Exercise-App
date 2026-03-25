import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/body_scan_service.dart';
import '../../services/workout_recommendation_engine.dart';
import 'body_scan_screen.dart';

class BodyScanResultScreen extends StatefulWidget {
  final BodyScanResult result;
  final File? imageFile;

  const BodyScanResultScreen({
    super.key,
    required this.result,
    this.imageFile,
  });

  @override
  State<BodyScanResultScreen> createState() => _BodyScanResultScreenState();
}

class _BodyScanResultScreenState extends State<BodyScanResultScreen>
    with SingleTickerProviderStateMixin {
  String _selectedMode = 'gym'; // 'gym' or 'yoga'
  late SmartWorkoutPlan _workoutPlan;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _generatePlan();
    
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
    
    // Light status bar for premium dark feel if we use it, but keeping scaffold background
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    );
  }
  
  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _generatePlan() {
    _workoutPlan = WorkoutRecommendationEngine.generatePlan(
      bodyType: widget.result.type,
      mode: _selectedMode,
    );
  }

  Color _getBodyTypeColor() {
    switch (widget.result.type) {
      case BodyType.fat:
        return const Color(0xFFEF476F); // Premium soft red
      case BodyType.lean:
        return const Color(0xFF06D6A0); // Premium mint green
      case BodyType.fit:
      default:
        return const Color(0xFF118AB2); // Premium deep blue
    }
  }

  String _getBodyTypeLabel() {
    switch (widget.result.type) {
      case BodyType.fat:
        return 'Endomorph (Fat)';
      case BodyType.lean:
        return 'Ectomorph (Lean)';
      case BodyType.fit:
      default:
        return 'Mesomorph (Fit)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── APP BAR ──
              SliverAppBar(
                backgroundColor: const Color(0xFFF7F8FA),
                elevation: 0,
                pinned: true,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                        )
                      ]
                    ),
                    child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  'Analysis Complete',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const BodyScanScreen()),
                          (route) => route.isFirst);
                    },
                    child: Text(
                      'Retake',
                      style: GoogleFonts.outfit(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── PREMIUM BODY TYPE HERO CARD ──
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getBodyTypeColor().withValues(alpha: 0.15),
                              Colors.white,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: _getBodyTypeColor().withValues(alpha: 0.1),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Image or Icon
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      )
                                    ],
                                    image: widget.imageFile != null
                                        ? DecorationImage(
                                            image: FileImage(widget.imageFile!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: widget.imageFile == null
                                      ? Icon(Icons.person, size: 40, color: _getBodyTypeColor())
                                      : null,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getBodyTypeColor(),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'PROFILE MATCH',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _getBodyTypeLabel(),
                                        style: GoogleFonts.outfit(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // AI Description block
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.auto_awesome, color: _getBodyTypeColor(), size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      widget.result.description,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // ── DIET PLAN PREMIUM CARD ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nutrition Strategy',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Icon(Icons.restaurant, color: AppColors.textSecondary, size: 24),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E), // Sleek dark card
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _workoutPlan.dietPlanTitle,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _workoutPlan.dietPlanDetails,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.8),
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // ── WORKOUT PLAN GENERATOR ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Action Plan',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timer, size: 14, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  '${_workoutPlan.totalDurationMin} Min',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Sleek Custom Segmented Control
                      Container(
                        height: 56,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0xFFEBEBEB)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        ),
                        child: Row(
                          children: [
                            _buildSegmentBtn('Gym Mode', 'gym', Icons.fitness_center),
                            _buildSegmentBtn('Yoga Mode', 'yoga', Icons.self_improvement),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Dynamic Workout Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: _selectedMode == 'gym' 
                              ? const Color(0xFFEAF4F0) // Subtle gym tint
                              : const Color(0xFFFDF4E5), // Subtle yoga tint
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _selectedMode == 'gym' ? Icons.directions_run : Icons.spa,
                              color: _selectedMode == 'gym' ? AppColors.primary : const Color(0xFFE69A45),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                _workoutPlan.message,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Text(
                        'Exercises Sequence',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // ── EXERCISE LIST ──
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final exercise = _workoutPlan.exercises[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ]
                        ),
                        child: Row(
                          children: [
                            // Beautiful numbered icon replacement since images might not map directly
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: _selectedMode == 'gym' 
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : const Color(0xFFFDF4E5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: _selectedMode == 'gym' ? AppColors.primary : const Color(0xFFE69A45),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise['name'] ?? 'Exercise',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F5F7),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          exercise['category']?.toString().toUpperCase() ?? 'MIXED',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(Icons.repeat, size: 12, color: AppColors.textMuted),
                                      const SizedBox(width: 4),
                                      Text(
                                        exercise['reps'] ?? '15 reps',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: _workoutPlan.exercises.length,
                  ),
                ),
              ),
              
              // ── BOTTOM SPACING ──
              SliverToBoxAdapter(
                child: const SizedBox(height: 60),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentBtn(String title, String mode, IconData icon) {
    bool isSelected = _selectedMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMode = mode;
            _generatePlan();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]
                : [],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
