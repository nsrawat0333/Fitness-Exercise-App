import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/ufc_model.dart';
import '../../services/progress_service.dart';
import '../../data/exercise_assets.dart';
import '../../models/gym_course_model.dart'; // To convert UFC exercises
import '../workout_player_screen.dart';

/// Shows day-by-day training plan for a UFC course
class UFCCourseDetailScreen extends StatefulWidget {
  final UFCCourse course;
  const UFCCourseDetailScreen({super.key, required this.course});

  @override
  State<UFCCourseDetailScreen> createState() => _UFCCourseDetailScreenState();
}

class _UFCCourseDetailScreenState extends State<UFCCourseDetailScreen> {
  final _progress = ProgressService();
  List<int> _completedDays = [];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    await _progress.init();
    setState(() {
      _completedDays = _progress.getUFCCompletedDays(widget.course.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Both styles look great with Sage Green, but we can tint the color slightly
    final isD = widget.course.style == UFCStyle.dagestani;
    final accent = isD ? const Color(0xFFC04F4F) : AppColors.sageGreen;

    return Scaffold(
      backgroundColor: AppColors.sageBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.course.name, style: AppTextStyles.sageTitle.copyWith(fontSize: 18)),
        iconTheme: const IconThemeData(color: AppColors.sageTextDark),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          // Course info
          Container(
            padding: const EdgeInsets.all(16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.course.description, style: TextStyle(color: AppColors.sageTextMuted, fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _Chip(text: widget.course.level, color: accent, bgColor: accent.withValues(alpha: 0.15)),
                    const SizedBox(width: 8),
                    _Chip(text: widget.course.duration, color: AppColors.sageTextDark, bgColor: AppColors.sageGreenLight),
                    const SizedBox(width: 8),
                    _Chip(text: isD ? 'Dagestani' : 'Irish', color: AppColors.sageTextMuted, bgColor: AppColors.border),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Days
          ...widget.course.days.map((day) => _DayCard(
                day: day,
                accent: accent,
                courseName: widget.course.name,
                isCompleted: _completedDays.contains(day.dayNumber),
                onComplete: () async {
                  await _progress.completeUFCDay(widget.course.name, day.dayNumber);
                  _loadProgress();
                },
              )),
          // Rest day
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.sageGreenLight.withValues(alpha: 0.5),
                  ),
                  child: Center(child: Text('7', style: TextStyle(color: AppColors.sageTextMuted, fontSize: 16, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(width: 12),
                const Text('REST & RECOVERY 😴', style: TextStyle(color: AppColors.sageTextMuted, fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _DayCard extends StatefulWidget {
  final UFCDay day;
  final Color accent;
  final String courseName;
  final bool isCompleted;
  final VoidCallback onComplete;

  const _DayCard({required this.day, required this.accent, required this.courseName, required this.isCompleted, required this.onComplete});

  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard> {
  bool _expanded = false;

  void _startDailyWorkout() {
    // Convert UFCExercises to CourseExercises for the Player
    final List<CourseExercise> exercises = widget.day.exercises.map((e) {
      // Very naive conversion: parse seconds from duration, or fallback
      int duration = 30; // default
      if (e.repsOrDuration.contains('sec')) {
        duration = int.tryParse(e.repsOrDuration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 30;
      }

      return CourseExercise(
        exerciseId: e.name.toLowerCase().replaceAll(' ', '_'),
        name: e.name,
        durationSeconds: duration,
      );
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutPlayerScreen(exercises: exercises, courseName: '${widget.courseName} - Day ${widget.day.dayNumber}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.isCompleted
            ? widget.accent.withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.isCompleted ? widget.accent.withValues(alpha: 0.5) : Colors.transparent,
        ),
        boxShadow: widget.isCompleted ? [] : [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isCompleted ? widget.accent : AppColors.sageBg,
                    ),
                    child: Center(
                      child: widget.isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : Text('${widget.day.dayNumber}', style: TextStyle(color: widget.accent, fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Day ${widget.day.dayNumber} — ${widget.day.focus}',
                          style: AppTextStyles.sageTitle.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.day.exercises.length} exercises',
                          style: TextStyle(color: AppColors.sageTextMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.sageTextMuted,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(color: AppColors.border, height: 1),
            ...widget.day.exercises.map((ex) {
              final assetPath = ExerciseAssets.getAssetForExercise(ex.name);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.sageBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExerciseMediaWidget(assetPath: assetPath, fit: BoxFit.cover, isThumbnail: true),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ex.name, style: AppTextStyles.sageTitle.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                            '${ex.sets} sets × ${ex.repsOrDuration}',
                            style: TextStyle(color: widget.accent, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            
            // Start Workout & Mark Complete Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _startDailyWorkout,
                      icon: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.accent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      label: const Text(
                        'START WORKOUT',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: widget.isCompleted ? null : widget.onComplete,
                      style: TextButton.styleFrom(
                        foregroundColor: widget.accent,
                      ),
                      child: Text(
                        widget.isCompleted ? 'COMPLETED ✓' : 'MARK AS DONE',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: widget.isCompleted ? AppColors.sageGreen : AppColors.sageTextMuted),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color;
  final Color bgColor;
  const _Chip({required this.text, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}
