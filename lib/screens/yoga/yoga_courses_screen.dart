import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../constants/app_colors.dart';
import '../../models/yoga_models.dart';
import '../../services/yoga_service.dart';
import 'yoga_30day_screen.dart';
import 'yoga_diet_screen.dart';
import 'yoga_custom_plan_screen.dart';
import 'yoga_course_detail_screen.dart';

class YogaCoursesScreen extends StatefulWidget {
  const YogaCoursesScreen({super.key});

  @override
  State<YogaCoursesScreen> createState() => _YogaCoursesScreenState();
}

class _YogaCoursesScreenState extends State<YogaCoursesScreen> {
  String _selectedFocusKey = 'all';

  final List<Map<String, String>> _focusTabs = [
    {'key': 'all', 'label': 'All'},
    {'key': 'weight_loss', 'label': 'Weight Loss'},
    {'key': 'flexibility', 'label': 'Flexibility'},
    {'key': 'stress_relief', 'label': 'Stress Relief'},
    {'key': 'back_pain', 'label': 'Back Pain'},
    {'key': 'abs_core', 'label': 'Abs & Core'},
    {'key': 'full_body', 'label': 'Full Body'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildProgressCard(),
            const SizedBox(height: 24),
            _buildFullBodyCourseCard(),
            const SizedBox(height: 24),
            _buildFocusSection(),
            const SizedBox(height: 24),
            _buildDietPlanSection(),
            const SizedBox(height: 24),
            _buildCustomPlanSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF9F7F3),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'YOGA STUDIO',
        style: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // PROGRESS CARD
  // ══════════════════════════════════════════════════════════
  Widget _buildProgressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5B7E5F), Color(0xFF729B79)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5B7E5F).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Progress',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '30 Day Plan',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 0.03,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Day 1 of 30',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                Text(
                  'Keep it up! 🧘',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // FULL BODY YOGA COURSE
  // ══════════════════════════════════════════════════════════
  Widget _buildFullBodyCourseCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yoga Programs',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const Yoga30DayScreen(),
              ));
            },
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B7E5F), Color(0xFF3D8B6E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5B7E5F).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Icon(
                      Icons.self_improvement,
                      size: 120,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '30 DAYS',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'FULL BODY\nYOGA COURSE',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Progressive 30-day program\nfor total body transformation.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // FOCUS AREA SECTION
  // ══════════════════════════════════════════════════════════
  Widget _buildFocusSection() {
    final poses = YogaService.getPosesForFocusKey(_selectedFocusKey);
    final courseSessions = YogaService.getCourseSessions(_selectedFocusKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Focus Areas',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Tabs
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _focusTabs.length,
            itemBuilder: (context, index) {
              final tab = _focusTabs[index];
              final isSelected = _selectedFocusKey == tab['key'];
              return GestureDetector(
                onTap: () => setState(() => _selectedFocusKey = tab['key']!),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5B7E5F) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? null
                        : Border.all(color: const Color(0xFFE0DCD4)),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF5B7E5F).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tab['label']!,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Course cards (Beginner / Intermediate / Advanced)
        ...courseSessions.map((session) {
          int levelIndex = session.difficulty == 'Beginner'
              ? 1
              : session.difficulty == 'Intermediate'
                  ? 2
                  : 3;
          return _buildCourseListItem(
            session: session,
            levelIndex: levelIndex,
          );
        }),
        const SizedBox(height: 16),
        // Poses row
        if (poses.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Poses',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: poses.length > 10 ? 10 : poses.length,
              itemBuilder: (context, index) {
                final pose = poses[index];
                return Container(
                  width: 115,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 65,
                        height: 65,
                        child: pose.animation.isNotEmpty
                            ? Lottie.asset(pose.animation, fit: BoxFit.contain)
                            : pose.image.isNotEmpty
                                ? Image.asset(
                                    pose.image,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.self_improvement,
                                      color: Color(0xFF5B7E5F),
                                      size: 28,
                                    ),
                                  )
                                : const Icon(
                                    Icons.self_improvement,
                                    color: Color(0xFF5B7E5F),
                                    size: 28,
                                  ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          pose.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCourseListItem({
    required YogaSession session,
    required int levelIndex,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => YogaCourseDetailScreen(session: session),
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: session.poses.isNotEmpty && session.poses.first.animation.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Lottie.asset(session.poses.first.animation, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.self_improvement, color: Color(0xFF5B7E5F), size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${session.duration} • ${session.poses.length} Poses',
                    style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(3, (i) {
                      final isActive = i < levelIndex;
                      return Icon(
                        Icons.bolt,
                        size: 16,
                        color: isActive ? const Color(0xFF5B7E5F) : const Color(0xFFE0E0E0),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // DIET PLAN
  // ══════════════════════════════════════════════════════════
  Widget _buildDietPlanSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const YogaDietScreen()));
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD4A574), Color(0xFFC8956C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.restaurant_menu, color: Colors.white, size: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yoga Diet Plan',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ayurvedic meals for your practice',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // CUSTOM PLAN
  // ══════════════════════════════════════════════════════════
  Widget _buildCustomPlanSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Plan',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const YogaCustomPlanScreen(),
              ));
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(color: const Color(0xFF5B7E5F).withValues(alpha: 0.3)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFF5B7E5F), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Generate Personalized Yoga Plan',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5B7E5F),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
