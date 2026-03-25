import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../data/gym_challenge_data.dart';
import '../../models/yoga_models.dart';
import '../../services/yoga_service.dart';
import '../gym/courses/workout_flow_screen.dart';

class YogaFocusScreen extends StatefulWidget {
  const YogaFocusScreen({super.key});

  @override
  State<YogaFocusScreen> createState() => _YogaFocusScreenState();
}

class _YogaFocusScreenState extends State<YogaFocusScreen> {
  final List<String> _focusAreas = [
    'Weight Loss',
    'Flexibility',
    'Stress Relief',
    'Back Pain',
    'Abs Core',
    'Full Body',
  ];

  String _selectedFocus = 'Weight Loss';
  List<YogaSession> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  void _loadSessions() {
    setState(() {
      _sessions = YogaService.getSessionsForFocus(_selectedFocus);
    });
  }

  void _startSession(YogaSession session) {
    final gymExercises = session.poses.map((p) {
      return GymExercise(
        id: p.name.toLowerCase().replaceAll(' ', '_'),
        name: p.name,
        category: p.category,
        muscleGroup: p.focusAreas,
        difficulty: session.difficulty,
        durationSeconds: p.durationSeconds,
        performDuration: p.durationSeconds,
        previewDuration: 20,
        instructions: p.steps,
        imageAsset: p.image,
        animationLottie: p.animation.isNotEmpty ? p.animation : null,
      );
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutFlowScreen(
          exercises: gymExercises,
          dayIndex: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildFocusTabs(),
            Expanded(
              child: _sessions.isEmpty
                  ? Center(
                      child: Text(
                        'No sessions found for $_selectedFocus',
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      itemCount: _sessions.length,
                      itemBuilder: (context, index) {
                        return _buildSessionCard(_sessions[index], index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24),
          ),
          const Expanded(
            child: Center(
              child: Text('Focus Areas',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildFocusTabs() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _focusAreas.length,
        itemBuilder: (context, index) {
          final focus = _focusAreas[index];
          final isSelected = focus == _selectedFocus;
          return GestureDetector(
            onTap: () {
              _selectedFocus = focus;
              _loadSessions();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF5EC6C6) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF5EC6C6).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                focus,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionCard(YogaSession session, int index) {
    // Alternate card background colors slightly
    final colors = [
      AppColors.cardLight,
      const Color(0xFFD6F2F2),
      const Color(0xFFE8F8F8),
    ];
    final bgColor = colors[index % colors.length];

    return GestureDetector(
      onTap: () => _startSession(session),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    session.difficulty,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF5EC6C6),
                    ),
                  ),
                ),
                Icon(Icons.play_circle_fill_rounded,
                    color: const Color(0xFF5EC6C6), size: 36),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              session.title,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  session.duration,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.fitness_center_rounded,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${session.poses.length} Poses',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
