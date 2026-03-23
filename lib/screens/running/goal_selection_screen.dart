import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import 'active_run_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Race',
      'subtitle': 'Compete and track your performance',
      'icon': Icons.flag,
      'color': AppColors.sageGreenLight,
    },
    {
      'title': 'Run a specific distance',
      'subtitle': 'Run a fixed distance like 5KM, 7KM',
      'icon': Icons.terrain,
      'color': Colors.orangeAccent.shade100,
    },
    {
      'title': 'Run a first 5k',
      'subtitle': 'Perfect for beginners starting out',
      'icon': Icons.child_care,
      'color': Colors.pinkAccent.shade100,
    },
    {
      'title': 'General training',
      'subtitle': 'Free running and practice sessions',
      'icon': Icons.favorite,
      'color': AppColors.sageGreenLight,
    },
    {
      'title': 'Post-natal plan',
      'subtitle': 'Gentle return to active wellness',
      'icon': Icons.person,
      'color': Colors.deepOrangeAccent.shade100,
    },
    {
      'title': 'Functional fitness',
      'subtitle': 'Strength for everyday longevity',
      'icon': Icons.fitness_center,
      'color': AppColors.sageGreen,
    },
    {
      'title': 'Post-injury recovery',
      'subtitle': 'Safe, guided rehabilitation routines',
      'icon': Icons.medical_services,
      'color': Colors.pinkAccent.shade100,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sageDark,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'STEP 02 — PLANNING',
                        style: AppTextStyles.sageSubtitle.copyWith(
                          color: Colors.orangeAccent.shade100,
                          fontSize: 10,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('What is your goal?', style: AppTextStyles.sageTitle.copyWith(color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(
                    'Select a focus area to help us craft your restorative fitness journey.',
                    style: AppTextStyles.sageSubtitle.copyWith(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 32),

                  // Goal Cards List
                  ...List.generate(_goals.length, (index) {
                    final goal = _goals[index];
                    final isSelected = _selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        height: 110,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.white.withValues(alpha: 0.15) 
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: isSelected ? AppColors.sageGreen : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: [
                            // Big background icon
                            Positioned(
                              right: -20,
                              bottom: -20,
                              child: Icon(
                                goal['icon'],
                                size: 100,
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            // Content
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppColors.sageGreen : Colors.white.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          goal['icon'],
                                          color: isSelected ? Colors.white : goal['color'],
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(goal['title'], style: AppTextStyles.sageCardTitle),
                                  const SizedBox(height: 4),
                                  Text(
                                    goal['subtitle'], 
                                    style: AppTextStyles.sageSubtitle.copyWith(fontSize: 12, color: Colors.white60),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 100), // Padding for floating button
                ],
              ),
            ),

            // Floating Continue Button
            Positioned(
              bottom: 40,
              left: 24,
              right: 24,
              child: GestureDetector(
                onTap: () {
                  // Navigate to the Active Map setup
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_) => ActiveRunScreen(goalTitle: _goals[_selectedIndex]['title']),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.sageGreen,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue', style: AppTextStyles.sageCardTitle),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
