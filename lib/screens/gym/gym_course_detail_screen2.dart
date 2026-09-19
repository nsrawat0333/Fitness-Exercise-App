import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../data/gym_course_card_images.dart';
import '../../models/gym_course_model.dart';
import '../../services/progress_service.dart';
import '../../data/exercise_assets.dart';
import '../workout_player_screen.dart';

/// Course detail — shows Beginner/Intermediate/Advanced tabs with exercise lists
class GymCourseDetail2Screen extends StatefulWidget {
  final GymCourseInfo course;
  const GymCourseDetail2Screen({super.key, required this.course});

  @override
  State<GymCourseDetail2Screen> createState() => _GymCourseDetail2ScreenState();
}

class _GymCourseDetail2ScreenState extends State<GymCourseDetail2Screen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _progress = ProgressService();
  final _accent = AppColors.sageGreen;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.course.levels.length, vsync: this);
    _progress.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startWorkout() {
    final currentLevel = widget.course.levels[_tabController.index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutPlayerScreen(exercises: currentLevel.exercises, courseName: widget.course.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseImage = resolveGymCourseCardImage(widget.course);

    return Scaffold(
      backgroundColor: AppColors.sageBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.course.name,
          style: AppTextStyles.sageTitle.copyWith(fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: AppColors.sageTextDark),
      ),
      body: Column(
        children: [
          if (courseImage != null)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              height: 160,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                courseImage,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: AppColors.sageGreenLight),
              ),
            ),
          // Goal
          if (widget.course.goal.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.course.goal,
                  style: TextStyle(color: AppColors.sageTextMuted, fontSize: 13),
                ),
              ),
            ),
          const SizedBox(height: 8),
          // Level tabs
          if (widget.course.levels.length > 1)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
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
                  borderRadius: BorderRadius.circular(10),
                  color: _accent,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.sageTextMuted,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                tabs: widget.course.levels.map((l) {
                  final label = l.level == CourseLevel.beginner
                      ? 'BEGINNER'
                      : l.level == CourseLevel.intermediate
                          ? 'INTERMEDIATE'
                          : 'ADVANCED';
                  return Tab(text: label);
                }).toList(),
              ),
            ),
          const SizedBox(height: 12),
          // Exercise list
          Expanded(
            child: widget.course.levels.length > 1
                ? TabBarView(
                    controller: _tabController,
                    children: widget.course.levels.map((l) => _ExerciseList(
                          levelData: l,
                          accent: _accent,
                          courseName: widget.course.name,
                          progress: _progress,
                        )).toList(),
                  )
                : _ExerciseList(
                    levelData: widget.course.levels.first,
                    accent: _accent,
                    courseName: widget.course.name,
                    progress: _progress,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startWorkout,
        backgroundColor: AppColors.sageGreen,
        icon: const Icon(Icons.play_arrow, color: Colors.white),
        label: const Text('START WORKOUT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _ExerciseList extends StatelessWidget {
  final CourseLevelData levelData;
  final Color accent;
  final String courseName;
  final ProgressService progress;

  const _ExerciseList({
    required this.levelData,
    required this.accent,
    required this.courseName,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Headers
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                // Duration header
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer, color: accent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '⏱ ${levelData.totalDurationMinutes} min total',
                        style: TextStyle(color: accent, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        '${levelData.exercises.length} exercises',
                        style: TextStyle(color: AppColors.sageTextMuted, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                // Goal sub-header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: accent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.flag, color: accent, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Goal: ${levelData.goal}',
                        style: TextStyle(color: AppColors.sageTextDark, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Lazy-loaded Exercise cards
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final ex = levelData.exercises[i];
                final assetPath = ExerciseAssets.getAssetForExercise(ex.name);

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Render Media inline
                      Container(
                        width: 60,
                        height: 60,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.sageGreenLight.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExerciseMediaWidget(
                          assetPath: assetPath,
                          fit: BoxFit.contain,
                          isThumbnail: false,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ex.name,
                              style: AppTextStyles.sageTitle.copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.sageGreenLight.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _formatTime(ex.durationSeconds),
                                style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: levelData.exercises.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  static String _formatTime(int seconds) {
    if (seconds >= 60) {
      final min = seconds ~/ 60;
      final sec = seconds % 60;
      return sec > 0 ? '${min}m ${sec}s' : '$min min';
    }
    return '${seconds}s';
  }
}
