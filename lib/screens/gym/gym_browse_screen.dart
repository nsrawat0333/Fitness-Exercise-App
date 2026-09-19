import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../data/gym_course_card_images.dart';
import '../../data/gym_courses_data.dart';
import '../../models/gym_course_model.dart';
import 'gym_course_detail_screen2.dart';

/// Body type banner images
const _bodyTypeBanners = {
  'fat': 'assets/sections/challange/gym_fat_banner.jpg',
  'fit': 'assets/sections/challange/gym_fit_banner.jpg',
  'lean': 'assets/sections/challange/gym_lean_banner.jpg',
};

/// Browse all gym courses — body-type tabs + focus area listing
class GymBrowseScreen extends StatefulWidget {
  final String? gender;
  final String? preferredBodyType;

  const GymBrowseScreen({super.key, this.gender, this.preferredBodyType});

  @override
  State<GymBrowseScreen> createState() => _GymBrowseScreenState();
}

class _GymBrowseScreenState extends State<GymBrowseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _bodyType = 'fit';
  String? _lockedBodyType;

  @override
  void initState() {
    super.initState();
    _lockedBodyType = _normalizeBodyType(widget.preferredBodyType);
    if (_lockedBodyType != null) {
      _bodyType = _lockedBodyType!;
    }
    _tabController = TabController(length: 2, vsync: this);
  }

  String? _normalizeBodyType(String? value) {
    if (value == null) return null;
    final normalized = value.toLowerCase();
    if (normalized == 'fat' || normalized == 'fit' || normalized == 'lean') {
      return normalized;
    }
    return null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sageBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ALL COURSES',
          style: AppTextStyles.sageTitle.copyWith(fontSize: 20, letterSpacing: 1),
        ),
        iconTheme: const IconThemeData(color: AppColors.sageTextDark),
      ),
      body: Column(
        children: [
          // Section tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.sageGreen,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.sageTextMuted,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [
                Tab(text: 'BODY TYPE'),
                Tab(text: 'FOCUS AREA'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _BodyTypeCourseList(
                  bodyType: _bodyType,
                  lockedBodyType: _lockedBodyType,
                  onBodyTypeChanged: (bt) {
                    if (_lockedBodyType == null) {
                      setState(() => _bodyType = bt);
                    }
                  },
                ),
                _FocusCoursesGrid(gender: widget.gender),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// Body Type Course List Tab
// ════════════════════════════════════════════════════════
class _BodyTypeCourseList extends StatelessWidget {
  final String bodyType;
  final String? lockedBodyType;
  final ValueChanged<String> onBodyTypeChanged;

  const _BodyTypeCourseList({required this.bodyType, this.lockedBodyType, required this.onBodyTypeChanged});

  @override
  Widget build(BuildContext context) {
    final courses = GymCoursesData.getCoursesForBodyType(bodyType);
    final isLocked = lockedBodyType != null;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Body type selector
        if (!isLocked)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: ['fat', 'fit', 'lean'].map((type) {
                  final isActive = bodyType == type;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onBodyTypeChanged(type),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.sageGreen : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isActive
                              ? []
                              : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
                        ),
                        child: Center(
                          child: Text(
                            type.toUpperCase(),
                            style: TextStyle(
                              color: isActive ? Colors.white : AppColors.sageTextMuted,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.sageGreenLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 16, color: AppColors.sageGreen),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Showing AI-detected ${bodyType.toUpperCase()} section only',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.sageTextDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // Banner
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 140,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  _bodyTypeBanners[bodyType] ?? _bodyTypeBanners['fit']!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.sageGreenLight,
                    child: const Center(child: Icon(Icons.fitness_center, color: AppColors.sageGreen, size: 48)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16, left: 16,
                  child: Text(
                    '${bodyType.toUpperCase()} BODY PROGRAM',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Course list
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final course = courses[index];
                final imagePath = resolveGymCourseCardImage(course);
                final totalMin = course.levels.isNotEmpty ? course.levels.first.totalDurationMinutes : 0;
                final exCount = course.levels.isNotEmpty ? course.levels.first.exercises.length : 0;

                return _CourseListCard(
                  course: course,
                  imagePath: imagePath,
                  totalMin: totalMin,
                  exerciseCount: exCount,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GymCourseDetail2Screen(course: course)),
                    );
                  },
                );
              },
              childCount: courses.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════
// Focus Courses Grid Tab
// ════════════════════════════════════════════════════════
class _FocusCoursesGrid extends StatelessWidget {
  final String? gender;
  const _FocusCoursesGrid({this.gender});

  @override
  Widget build(BuildContext context) {
    final courses = GymCoursesData.getFocusCourses(gender: gender);

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        final imagePath = resolveGymCourseCardImage(course);
        final totalMin = course.levels.isNotEmpty ? course.levels.first.totalDurationMinutes : 0;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GymCourseDetail2Screen(course: course)),
            );
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // HD Background image
                if (imagePath != null)
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(color: AppColors.sageGreenLight),
                  )
                else
                  Container(color: AppColors.sageGreenLight),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
                // Content
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        course.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '⏱ $totalMin min',
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${course.levels.length}L',
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
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

// ════════════════════════════════════════════════════════
// Course List Card (for body-type tab)
// ════════════════════════════════════════════════════════
class _CourseListCard extends StatelessWidget {
  final GymCourseInfo course;
  final int totalMin;
  final int exerciseCount;
  final VoidCallback onTap;
  final String? imagePath;

  const _CourseListCard({
    required this.course,
    required this.totalMin,
    required this.exerciseCount,
    required this.onTap,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 90,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 66,
                height: 66,
                margin: const EdgeInsets.only(right: 12),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.sageGreenLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: imagePath != null
                    ? Image.asset(
                        imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(color: AppColors.sageGreenLight),
                      )
                    : Container(color: AppColors.sageGreenLight),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      course.name,
                      style: AppTextStyles.sageTitle.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      course.goal,
                      style: TextStyle(color: AppColors.sageTextMuted, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.sageGreenLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '⏱ $totalMin min',
                            style: const TextStyle(color: AppColors.sageGreen, fontSize: 9, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.sageBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$exerciseCount ex',
                            style: const TextStyle(color: AppColors.sageTextMuted, fontSize: 9, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 4),
                        ...course.levels.map((l) {
                          final label = l.level == CourseLevel.beginner ? 'B' : l.level == CourseLevel.intermediate ? 'I' : 'A';
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.sageBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(label, style: const TextStyle(color: AppColors.sageTextMuted, fontSize: 9, fontWeight: FontWeight.w700)),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColors.sageGreenLight, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
