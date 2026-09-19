import 'dart:async';

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../data/gym_course_card_images.dart';
import '../../data/gym_courses_data.dart';
import '../../models/gym_course_model.dart';
import '../../data/gym_user_data.dart';
import 'gym_course_detail_screen2.dart';
import 'gym_welcome_screen.dart';
import 'gym_browse_screen.dart';

/// Main Gym tab - workout browsing and custom plan entry points.
class GymMainScreen extends StatefulWidget {
  const GymMainScreen({super.key});

  @override
  State<GymMainScreen> createState() => _GymMainScreenState();
}

class _GymMainScreenState extends State<GymMainScreen> {
  static const double _popularCardScrollStep = 212;

  String? _gender;
  final ScrollController _popularScrollController = ScrollController();
  Timer? _popularAutoSlideTimer;

  @override
  void initState() {
    super.initState();
    final userData = GymUserData();
    _gender = userData.gender.toLowerCase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPopularAutoSlide();
    });
  }

  @override
  void dispose() {
    _popularAutoSlideTimer?.cancel();
    _popularScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final popularCourses = [
      ...GymCoursesData.fitCourses.take(3),
      ...GymCoursesData.commonFocusCourses.take(3),
    ];

    final focusCourses = GymCoursesData.commonFocusCourses;

    return Scaffold(
      backgroundColor: AppColors.sageBg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Title ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GYM',
                      style: AppTextStyles.sageTitle.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose your training path',
                      style: AppTextStyles.sageSubtitle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // ── Two Entry Mode Cards ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _EntryModeCard(
                            title: 'VIEW ALL\nWORKOUTS',
                            subtitle: 'Browse every course\nand focus area',
                            icon: Icons.grid_view_rounded,
                            color: AppColors.sageGreen,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      GymBrowseScreen(gender: _gender),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        // CUSTOM PLAN Card
                        Expanded(
                          child: _EntryModeCard(
                            title: 'CUSTOM\nPLAN',
                            subtitle: 'No camera?\nTake a quick quiz',
                            icon: Icons.assignment_rounded,
                            color: AppColors.sageGreenLight,
                            textColor: AppColors.sageTextDark,
                            onTap: () {
                              // Route to the existing questionnaire flow
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const GymWelcomeScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Popular Courses Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    Text(
                      'POPULAR COURSES',
                      style: AppTextStyles.sageTitle.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // ── Popular Courses Horizontal Scroll ──
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification &&
                        notification.dragDetails != null) {
                      _popularAutoSlideTimer?.cancel();
                    }
                    if (notification is ScrollEndNotification) {
                      _startPopularAutoSlide();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _popularScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: popularCourses.length,
                    itemBuilder: (context, index) {
                      final course = popularCourses[index];
                      return _PopularCourseCard(
                        course: course,
                        imagePath: _resolvePopularCourseImage(course),
                        onTap: () => _openCourseDetail(course),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ── Focus Areas Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                child: Text(
                  'FOCUS AREAS',
                  style: AppTextStyles.sageTitle.copyWith(fontSize: 16),
                ),
              ),
            ),

            // ── Focus Area Grid ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final course = focusCourses[index];
                  final imagePath = gymFocusAreaImages[course.focusArea];
                  return _FocusAreaCard(
                    course: course,
                    imagePath: imagePath,
                    onTap: () => _openCourseDetail(course),
                  );
                }, childCount: focusCourses.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCourseDetail(GymCourseInfo course) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GymCourseDetail2Screen(course: course)),
    );
  }

  String? _resolvePopularCourseImage(GymCourseInfo course) {
    final resolved = resolveGymCourseCardImage(course);
    if (resolved != null) {
      return resolved;
    }

    final fallbackPool = gymFocusAreaImages.values.toList(growable: false);
    if (fallbackPool.isEmpty) {
      return null;
    }

    final hash = course.name.codeUnits.fold<int>(0, (sum, code) => sum + code);
    return fallbackPool[hash % fallbackPool.length];
  }

  void _startPopularAutoSlide() {
    _popularAutoSlideTimer?.cancel();
    _popularAutoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _advancePopularCourses();
    });
  }

  void _advancePopularCourses() {
    if (!mounted || !_popularScrollController.hasClients) {
      return;
    }

    final position = _popularScrollController.position;
    if (position.maxScrollExtent <= 0) {
      return;
    }

    final nextOffset = _popularScrollController.offset + _popularCardScrollStep;
    if (nextOffset >= position.maxScrollExtent) {
      _popularScrollController
          .animateTo(
            position.maxScrollExtent,
            duration: const Duration(milliseconds: 550),
            curve: Curves.easeOut,
          )
          .whenComplete(() {
            if (mounted && _popularScrollController.hasClients) {
              _popularScrollController.jumpTo(0);
            }
          });
      return;
    }

    _popularScrollController.animateTo(
      nextOffset,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOut,
    );
  }
}

// ════════════════════════════════════════════════════════
// Entry Mode Card
// ════════════════════════════════════════════════════════
class _EntryModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _EntryModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.textColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: textColor, size: 24),
              ),
              const SizedBox(height: 14),
              // Title
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              // Subtitle
              Text(
                subtitle,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.8),
                  fontSize: 11,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              // Arrow
              Row(
                children: [
                  Text(
                    'START',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: textColor, size: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// Popular Course Card (Horizontal Scroll)
// ════════════════════════════════════════════════════════
class _PopularCourseCard extends StatelessWidget {
  final GymCourseInfo course;
  final String? imagePath;
  final VoidCallback onTap;

  const _PopularCourseCard({
    required this.course,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final focusImage = imagePath ?? resolveGymCourseCardImage(course);
    final totalMin = course.levels.isNotEmpty
        ? course.levels.first.totalDurationMinutes
        : 0;
    final exerciseCount = course.levels.isNotEmpty
        ? course.levels.first.exercises.length
        : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12, bottom: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image Half
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (focusImage != null)
                    Image.asset(
                      focusImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Container(color: AppColors.sageGreenLight),
                    )
                  else
                    Container(color: AppColors.sageGreenLight),
                  // Slight vignette
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),
                  // Removed Emoji Sticker
                ],
              ),
            ),
            // Text Half
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: AppTextStyles.sageTitle.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _MiniChip(
                          text: '⏱ $totalMin min',
                          color: AppColors.sageGreen,
                          bgColor: AppColors.sageGreenLight,
                        ),
                        const SizedBox(width: 4),
                        _MiniChip(
                          text: '$exerciseCount ex',
                          color: AppColors.sageTextMuted,
                          bgColor: AppColors.sageBg,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// Focus Area Card (Grid)
// ════════════════════════════════════════════════════════
class _FocusAreaCard extends StatelessWidget {
  final GymCourseInfo course;
  final String? imagePath;
  final VoidCallback onTap;

  const _FocusAreaCard({
    required this.course,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (imagePath != null)
              Image.asset(
                imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: AppColors.sageGreen),
              )
            else
              Container(color: AppColors.sageGreen),
            // Gradient overlay for readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            // Content
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${course.levels.length} Level${course.levels.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
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
}

// ════════════════════════════════════════════════════════
// Mini Info Chip
// ════════════════════════════════════════════════════════
class _MiniChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color bgColor;
  const _MiniChip({
    required this.text,
    required this.color,
    required this.bgColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
