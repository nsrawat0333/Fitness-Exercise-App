import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../data/yoga_poses_data.dart';
import '../../models/yoga_models.dart';

class YogaDietScreen extends StatefulWidget {
  const YogaDietScreen({super.key});

  @override
  State<YogaDietScreen> createState() => _YogaDietScreenState();
}

class _YogaDietScreenState extends State<YogaDietScreen> {
  String _selectedGoal = 'Weight Loss';
  late YogaDietPlan _currentPlan;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  void _loadPlan() {
    _currentPlan = YogaPosesData.dietPlans.firstWhere(
      (p) => p.goal == _selectedGoal,
      orElse: () => YogaPosesData.dietPlans.first,
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
            _buildGoalSelector(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                children: [
                  _buildMealCard('Early Morning', 'Empty Stomach', _currentPlan.morning, Icons.wb_twilight_rounded),
                  _buildMealCard('Breakfast', '8:00 AM - 9:00 AM', _currentPlan.breakfast, Icons.breakfast_dining_rounded),
                  _buildMealCard('Lunch', '1:00 PM - 2:00 PM', _currentPlan.lunch, Icons.lunch_dining_rounded),
                  _buildMealCard('Evening', '4:30 PM - 5:30 PM', _currentPlan.evening, Icons.local_cafe_rounded),
                  _buildMealCard('Dinner', '7:30 PM - 8:30 PM', _currentPlan.dinner, Icons.dinner_dining_rounded),
                ],
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
              child: Text('Diet Plans',
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

  Widget _buildGoalSelector() {
    final goals = YogaPosesData.dietPlans.map((e) => e.goal).toList();

    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          final isSelected = goal == _selectedGoal;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedGoal = goal;
                _loadPlan();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE57373) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFE57373).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                goal,
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

  Widget _buildMealCard(String title, String time, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          left: BorderSide(
            color: const Color(0xFFE57373),
            width: 4,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE57373).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFE57373), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.textPrimary.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
