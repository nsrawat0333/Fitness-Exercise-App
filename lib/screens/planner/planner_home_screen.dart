import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../models/planner_models.dart';
import '../../services/planner_state_service.dart';
import '../therapy/therapy_custom_exercise_screen.dart';
import '../therapy/therapy_screen.dart';
import '../../data/gym_challenge_data.dart';

class PlannerHomeScreen extends StatefulWidget {
  final String mode; // 'gym' or 'yoga'

  const PlannerHomeScreen({super.key, required this.mode});

  @override
  State<PlannerHomeScreen> createState() => _PlannerHomeScreenState();
}

class _PlannerHomeScreenState extends State<PlannerHomeScreen> {
  late PlannerStateService _plannerService;
  int _selectedWeekday = DateTime.now().weekday;

  final List<String> _weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    // In a real app we'd use Provider, but here we instantiate and listen
    _plannerService = PlannerStateService();
    _plannerService.setMode(widget.mode);
    _plannerService.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _plannerService.dispose();
    super.dispose();
  }

  Color _getThemeColor() {
    return widget.mode == 'gym' ? AppColors.primary : const Color(0xFFD4A574);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _plannerService.getTasksForDay(_selectedWeekday);
    final themeColor = _getThemeColor();
    final isDark = true;
    final bgCol = const Color(0xFF121212);
    final surfaceCol = const Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: bgCol,
      appBar: AppBar(
        backgroundColor: bgCol,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.mode == 'gym' ? 'Gym Planner' : 'Yoga Planner',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── MOTIVATION HEADER ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeColor.withValues(alpha: 0.8),
                      themeColor.withValues(alpha: 0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keep Pushing 🔥',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Your AI model recommends a gradual increase in your sets today. Avoid overtraining ⚠️",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      widget.mode == 'gym' ? Icons.fitness_center : Icons.self_improvement,
                      size: 48,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),

            // ── WEEKLY CALENDAR STRIP ──
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 7,
                itemBuilder: (context, index) {
                  int dayNum = index + 1;
                  bool isSelected = _selectedWeekday == dayNum;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedWeekday = dayNum;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 65,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? themeColor : surfaceCol,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? themeColor : Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weekLabels[index],
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Dot indicator if tasks exist
                          if (_plannerService.getTasksForDay(dayNum).isNotEmpty)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Colors.white : themeColor,
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── DAILY TO-DO LIST ──
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: surfaceCol,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: tasks.isEmpty
                    ? Center(
                        child: Text(
                          "Rest day! Take it easy. 💤",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            color: Colors.white54,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return _buildTaskCard(task, themeColor);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TherapyCustomExerciseScreen(returnSelection: true),
            ),
          );

          if (result != null && result is List<TherapyExerciseEntry>) {
            // Update plan state with the newly fetched custom exercises
            for (var entry in result) {
              _plannerService.addTask(_selectedWeekday, PlannerTask(
                id: DateTime.now().millisecondsSinceEpoch.toString() + entry.name,
                title: entry.name,
                category: 'Custom',
                targetReps: widget.mode == 'gym' ? 10 : 30,
                targetSets: widget.mode == 'gym' ? 3 : 1,
              ));
            }
          }
        },
      ),
    );
  }

  Widget _buildTaskCard(PlannerTask task, Color themeColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: task.isCompleted ? themeColor.withValues(alpha: 0.1) : const Color(0xFF252525),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: task.isCompleted ? themeColor.withValues(alpha: 0.3) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: GestureDetector(
          onTap: () {
            _plannerService.toggleTaskCompletion(_selectedWeekday, task.id);
            if (!task.isCompleted) { // Intentionally inverted because it updates in service
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Awesome! ML mapped progressive data 📈'),
                  backgroundColor: themeColor,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.isCompleted ? themeColor : Colors.transparent,
              border: Border.all(
                color: task.isCompleted ? themeColor : Colors.white54,
                width: 2,
              ),
            ),
            child: task.isCompleted 
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
          ),
        ),
        title: Text(
          task.title,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: task.isCompleted ? Colors.white70 : Colors.white,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              Icon(
                widget.mode == 'gym' ? Icons.repeat : Icons.timer, 
                size: 14, 
                color: themeColor
              ),
              const SizedBox(width: 6),
              Text(
                widget.mode == 'gym' 
                  ? "${task.targetSets.toInt()} sets x ${task.targetReps.toInt()} reps"
                  : "${task.targetReps.toInt()} Seconds",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white54,
                ),
              ),
              if (task.isCompleted) ...[
                const SizedBox(width: 12),
                const Icon(Icons.trending_up, size: 14, color: Colors.greenAccent),
              ],
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
          onPressed: () {
            _plannerService.removeTask(_selectedWeekday, task.id);
          },
        ),
      ),
    );
  }
}
