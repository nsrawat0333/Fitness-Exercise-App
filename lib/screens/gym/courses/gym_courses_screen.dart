import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../constants/app_colors.dart';
import '../../../data/gym_user_data.dart';
import '../../../data/gym_challenge_data.dart';
import 'gym_course_detail_screen.dart';
import 'gym_challenge_detail_screen.dart';
import 'gym_daily_workout_screen.dart';
import 'workout_flow_screen.dart';
import 'custom_workout_builder_screen.dart';
import 'home_workout_setup_screen.dart';
import '../diet_plan_screen.dart';

class GymCoursesScreen extends StatefulWidget {
  const GymCoursesScreen({super.key});

  @override
  State<GymCoursesScreen> createState() => _GymCoursesScreenState();
}

class _GymCoursesScreenState extends State<GymCoursesScreen> {
  late String _selectedBodyFocus;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<GymExercise> _searchResults = [];
  bool _isSearching = false;

  final List<String> _bodyFocusTabs = [
    'Full Body', 'Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps', 'Abs', 'Legs', 'Glutes',
  ];

  @override
  void initState() {
    super.initState();
    // User preference-based: show their focus area first
    String userFocus = GymUserData().focusArea;
    if (_bodyFocusTabs.contains(userFocus)) {
      _selectedBodyFocus = userFocus;
    } else {
      _selectedBodyFocus = 'Full Body';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.trim().isNotEmpty;
      if (_isSearching) {
        _searchResults = GymChallengeData.searchExercises(query);
      } else {
        _searchResults = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSearchBar(),
            if (_isSearching) ...[
              const SizedBox(height: 8),
              _buildSearchResults(),
            ] else ...[
              const SizedBox(height: 24),
              _buildWeeklyGoal(),
              const SizedBox(height: 24),
              _buildChallenges(),
              const SizedBox(height: 24),
              _buildBodyFocusSection(),
              const SizedBox(height: 24),
              _buildDietPlanSection(),
              const SizedBox(height: 24),
              _buildCustomWorkoutSection(),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
      // No bottomNavigationBar — removed as requested
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text(
            'HOME WORKOUT',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // SEARCH BAR — working search
  // ══════════════════════════════════════════════════════════
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search, color: Color(0xFF9E9E9E), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: GoogleFonts.outfit(fontSize: 15, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Search exercises...',
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 14,
                    color: const Color(0xFF9E9E9E),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_isSearching)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.close, color: Colors.grey, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // SEARCH RESULTS
  // ══════════════════════════════════════════════════════════
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, color: Colors.grey[400], size: 48),
              const SizedBox(height: 12),
              Text(
                'No exercises found for "$_searchQuery"',
                style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final ex = _searchResults[index];
        return _buildExerciseCardItem(ex);
      },
    );
  }

  Widget _buildExerciseCardItem(GymExercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          // Exercise image/animation
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE9EEF5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: exercise.animationLottie != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Lottie.asset(exercise.animationLottie!, fit: BoxFit.cover),
                  )
                : exercise.imageAsset != null && exercise.imageAsset!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          exercise.imageAsset!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.fitness_center, color: Color(0xFF005FF9), size: 28,
                          ),
                        ),
                      )
                    : const Icon(Icons.fitness_center, color: Color(0xFF005FF9), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildSmallChip(exercise.category.toUpperCase(), const Color(0xFF3B82F6)),
                    const SizedBox(width: 8),
                    Text(
                      '${exercise.durationSeconds}s',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildSmallChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // WEEKLY GOAL — Week-by-week progression
  // ══════════════════════════════════════════════════════════
  Widget _buildWeeklyGoal() {
    final userData = GymUserData();
    int totalDays = userData.totalPlanDays;
    int totalWeeks = userData.totalWeeks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Goal',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${userData.completedDays}',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  Text(
                    '/$totalDays days',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${userData.activity} Plan • $totalDays Days',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Week tabs
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: totalWeeks,
            itemBuilder: (context, weekIndex) {
              int week = weekIndex + 1;
              bool isWeekUnlocked = userData.isWeekUnlocked(week);
              bool isWeekDone = userData.isWeekCompleted(week);
              int startDay = (week - 1) * 7 + 1;
              int endDay = week * 7;
              if (endDay > totalDays) endDay = totalDays;

              return Container(
                width: 260,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isWeekDone
                      ? const Color(0xFFE8F5E9)
                      : isWeekUnlocked
                          ? Colors.white
                          : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isWeekDone
                        ? Colors.green.withValues(alpha: 0.4)
                        : isWeekUnlocked
                            ? const Color(0xFF3B82F6).withValues(alpha: 0.3)
                            : const Color(0xFFE0E0E0),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'WEEK $week',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isWeekDone
                                ? Colors.green[700]
                                : isWeekUnlocked
                                    ? const Color(0xFF3B82F6)
                                    : Colors.grey[500],
                            letterSpacing: 1.0,
                          ),
                        ),
                        if (isWeekDone)
                          Icon(Icons.check_circle, color: Colors.green[600], size: 22)
                        else if (!isWeekUnlocked)
                          Icon(Icons.lock, color: Colors.grey[400], size: 20),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Day circles for this week
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(endDay - startDay + 1, (i) {
                        int day = startDay + i;
                        bool isDone = userData.isDayCompleted(day);
                        bool isUnlocked = isWeekUnlocked && userData.isDayUnlocked(day);

                        return GestureDetector(
                          onTap: isUnlocked && !isDone
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => GymDailyWorkoutScreen(dayIndex: day),
                                    ),
                                  );
                                }
                              : null,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? Colors.green
                                  : isUnlocked
                                      ? const Color(0xFF3B82F6)
                                      : const Color(0xFFE0E0E0),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isDone
                                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                                  : Text(
                                      '$day',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: isUnlocked ? Colors.white : Colors.grey[500],
                                      ),
                                    ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    // Status text
                    Text(
                      isWeekDone
                          ? '✓ Week completed!'
                          : isWeekUnlocked
                              ? 'Tap a day to start'
                              : 'Complete previous week to unlock',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isWeekDone
                            ? Colors.green[600]
                            : isWeekUnlocked
                                ? const Color(0xFF3B82F6)
                                : Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Welcome card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: const AssetImage('assets/images/gym/gender_male.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Welcome back! Today's your chance to shine.",
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  // HOME WORKOUT — Full Body Course + Create Program
  // ══════════════════════════════════════════════════════════
  Widget _buildChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Home Workout',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Full Body Workout Course card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const GymChallengeDetailScreen(),
              ));
            },
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: 20,
                    width: 160,
                    height: 180,
                    child: Image.asset(
                      'assets/images/gym/goal_build_muscle_male.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomRight,
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
                          child: Text('28 DAYS', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'FULL BODY\nWORKOUT COURSE',
                          style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
                        ),
                        const Spacer(),
                        Text(
                          'Complete body-toning program\nfor all muscle groups.',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.white70, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Create Custom Program button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const HomeWorkoutSetupScreen(),
              ));
            },
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFF3B82F6), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Create Personalized Program',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════
  // BODY FOCUS SECTION — real exercises from catalog
  // ══════════════════════════════════════════════════════════
  Widget _buildBodyFocusSection() {
    // Get exercises for selected category
    final categoryExercises = GymChallengeData.getExercisesByCategory(_selectedBodyFocus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Body Focus',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Tabs
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _bodyFocusTabs.length,
            itemBuilder: (context, index) {
              final tab = _bodyFocusTabs[index];
              final isSelected = _selectedBodyFocus == tab;
              return GestureDetector(
                onTap: () => setState(() => _selectedBodyFocus = tab),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(18),
                    border: isSelected ? Border.all(color: const Color(0xFF3B82F6), width: 1.5) : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tab,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[600],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Difficulty-based course cards for this category
        ...['Beginner', 'Intermediate', 'Advanced'].map((level) {
          final levelExercises = categoryExercises.where((ex) {
            if (level == 'Beginner') return ex.difficulty == 'beginner';
            if (level == 'Intermediate') return ex.difficulty == 'intermediate';
            return ex.difficulty == 'advanced';
          }).toList();

          if (levelExercises.isEmpty) return const SizedBox.shrink();

          int days = level == 'Beginner' ? 7 : (level == 'Intermediate' ? 14 : 30);
          int duration = level == 'Beginner' ? 15 : (level == 'Intermediate' ? 24 : 30);
          int levelIndex = level == 'Beginner' ? 1 : (level == 'Intermediate' ? 2 : 3);

          return _buildWorkoutListItem(
            title: '$_selectedBodyFocus $level',
            time: '$duration mins',
            exercises: '${levelExercises.length} Exercises',
            levelIndex: levelIndex,
            exerciseList: levelExercises,
          );
        }),
        const SizedBox(height: 8),
        // Show some actual exercises from this category
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Exercises in ${_selectedBodyFocus}',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categoryExercises.length > 10 ? 10 : categoryExercises.length,
            itemBuilder: (context, index) {
              final ex = categoryExercises[index];
              return Container(
                width: 110,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: ex.animationLottie != null
                          ? Lottie.asset(ex.animationLottie!, fit: BoxFit.contain)
                          : ex.imageAsset != null && ex.imageAsset!.isNotEmpty
                              ? Image.asset(
                                  ex.imageAsset!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.fitness_center,
                                    color: const Color(0xFF005FF9),
                                    size: 28,
                                  ),
                                )
                              : Icon(Icons.fitness_center, color: const Color(0xFF005FF9), size: 28),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        ex.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
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
    );
  }

  Widget _buildWorkoutListItem({
    required String title,
    required String time,
    required String exercises,
    required int levelIndex,
    List<GymExercise>? exerciseList,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => GymCourseDetailScreen(
            courseName: title,
            duration: time,
            difficulty: levelIndex == 1 ? 'Beginner' : (levelIndex == 2 ? 'Intermediate' : 'Advanced'),
            imagePath: 'assets/images/gym/goal_keep_fit_male.png',
          )
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
                color: const Color(0xFFE9EEF5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: exerciseList != null && exerciseList.isNotEmpty && exerciseList.first.animationLottie != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Lottie.asset(exerciseList.first.animationLottie!, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.fitness_center, color: Color(0xFF005FF9), size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$time • $exercises',
                    style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(3, (i) {
                      final isActive = i < levelIndex;
                      return Icon(
                        Icons.bolt,
                        size: 16,
                        color: isActive ? const Color(0xFF3B82F6) : const Color(0xFFE0E0E0),
                      );
                    }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // DIET PLAN SECTION
  // ══════════════════════════════════════════════════════════
  Widget _buildDietPlanSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DietPlanScreen()));
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
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
                      'Your Diet Plan',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Personalized meals based on your ${GymUserData().motivation.toLowerCase()} goal',
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
  // CUSTOM WORKOUT — 100 exercises, select + timer
  // ══════════════════════════════════════════════════════════
  Widget _buildCustomWorkoutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Workout',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const CustomWorkoutBuilderScreen(),
              ));
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFF5F5F5),
                border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_circle_outline, color: Color(0xFF3B82F6)),
                  const SizedBox(width: 8),
                  Text(
                    'Create Your Own Plan',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Show saved custom plans if any
          if (GymUserData().customPlanExercises.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.playlist_play, color: Color(0xFF3B82F6), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Custom Plan',
                          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black),
                        ),
                        Text(
                          '${GymUserData().customPlanExercises.length} exercises',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to workout with custom exercises
                      List<GymExercise> customExercises = GymUserData().customPlanExercises.map((e) {
                        return GymExercise(
                          name: e['name'] ?? '',
                          durationSeconds: e['duration'] ?? 30,
                          imageAsset: e['image'],
                          animationLottie: e['lottie'],
                          videoAsset: e['video'],
                        );
                      }).toList();
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => WorkoutFlowScreen(
                          exercises: customExercises,
                          dayIndex: 0,
                        ),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('START', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
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
