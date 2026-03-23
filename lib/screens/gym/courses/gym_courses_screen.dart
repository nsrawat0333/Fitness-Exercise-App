import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import '../../../data/gym_user_data.dart';
import 'gym_course_detail_screen.dart';
import 'gym_challenge_detail_screen.dart';

class GymCoursesScreen extends StatefulWidget {
  const GymCoursesScreen({super.key});

  @override
  State<GymCoursesScreen> createState() => _GymCoursesScreenState();
}

class _GymCoursesScreenState extends State<GymCoursesScreen> {
  int _bottomNavIndex = 0;
  late String _selectedBodyFocus;

  final List<String> _bodyFocusTabs = [
    'Abs', 'Arm', 'Chest', 'Leg', 'Full Body', 'Shoulder & Back', 'Butt'
  ];

  @override
  void initState() {
    super.initState();
    _selectedBodyFocus = GymUserData().focusArea;
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
            const SizedBox(height: 24),
            _buildWeeklyGoal(),
            const SizedBox(height: 24),
            _buildChallenges(),
            const SizedBox(height: 24),
            _buildBodyFocusSection(),
            const SizedBox(height: 24),
            _buildCustomWorkoutSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false, // Don't show back button matching image
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search, color: Color(0xFF9E9E9E), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search workouts, plans...',
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 14,
                    color: const Color(0xFF9E9E9E),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyGoal() {
    int weeklyGoal = GymUserData().weeklyGoalDays;

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
                    '0',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  Text(
                    '/$weeklyGoal',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.edit, size: 14, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // goal progress grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final day = i + 1;
              final isCompleted = day <= 0; // Currently mocking 0 completed days
              final isTarget = day <= weeklyGoal;

              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.primary : const Color(0xFFE4E0D8),
                  shape: BoxShape.circle,
                  border: isTarget && !isCompleted
                      ? Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isCompleted ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        // Welcome back card
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

  Widget _buildChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Challenge',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildChallengeCard(
                color: const Color(0xFF005FF9),
                days: '28 DAYS',
                title: 'FULL BODY\nCHALLENGE',
                desc: 'Start your body-toning journey to target all muscle groups and build your dream body in 4 weeks!',
                image: 'assets/images/gym/goal_build_muscle_male.png',
              ),
              _buildChallengeCard(
                color: const Color(0xFF00ACC1),
                days: '30 DAYS',
                title: 'GET RIPPED\nWITH DUMBBELL',
                desc: 'Use dumbbells to build bigger muscles and boost full-body strength in 30 days!',
                image: 'assets/images/gym/goal_keep_fit_male.png',
              ),
              _buildChallengeCard(
                color: const Color(0xFF4527A0),
                days: '30 DAYS',
                title: 'SIX PACK\nCHALLENGE',
                desc: 'Crush this challenge and carve out your six-pack in no time!',
                image: 'assets/images/gym/goal_lose_weight_male.png',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeCard({
    required Color color,
    required String days,
    required String title,
    required String desc,
    required String image,
  }) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Background graphic / image
          Positioned(
            right: -20,
            bottom: 60,
            width: 180,
            height: 200,
            child: Image.asset(image, fit: BoxFit.contain, alignment: Alignment.bottomRight),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  days,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const Spacer(),
                Text(
                  desc,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const GymChallengeDetailScreen()
                    ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'START',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: color,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyFocusSection() {
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
        // List of workouts
        ...List.generate(3, (index) {
          final levels = ['Beginner', 'Intermediate', 'Advanced'];
          final times = [15, 24, 27];
          final exCount = [16, 21, 21];
          final level = levels[index];
          final time = times[index];
          final exc = exCount[index];

          return _buildWorkoutListItem(
            title: '$_selectedBodyFocus $level',
            time: '$time mins',
            exercises: '$exc Exercises',
            levelIndex: index + 1, // 1 to 3 lightning bolts
          );
        }),
      ],
    );
  }

  Widget _buildWorkoutListItem({
    required String title,
    required String time,
    required String exercises,
    required int levelIndex,
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
            // Placeholder Image Box for later DB injection
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE9EEF5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.fitness_center, color: Color(0xFF005FF9), size: 32),
            ),
            const SizedBox(width: 16),
            // Texts
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
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
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
          // Simple placeholder for custom workout button
          Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFF5F5F5),
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
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      onTap: (i) => setState(() => _bottomNavIndex = i),
      selectedItemColor: const Color(0xFF3B82F6),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Training'),
        BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Discover'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Settings'),
      ],
    );
  }
}
