import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/diet_plan_data.dart';
import '../../data/gym_user_data.dart';

class DietPlanScreen extends StatelessWidget {
  const DietPlanScreen({super.key});

  IconData _getMealIcon(String iconName) {
    switch (iconName) {
      case 'breakfast_dining': return Icons.breakfast_dining;
      case 'lunch_dining': return Icons.lunch_dining;
      case 'dinner_dining': return Icons.dinner_dining;
      case 'apple': return Icons.apple;
      case 'cookie': return Icons.cookie;
      case 'sports': return Icons.sports_gymnastics;
      default: return Icons.restaurant;
    }
  }

  Color _getMealColor(int index) {
    final colors = [
      const Color(0xFFFFA726), // Orange
      const Color(0xFF66BB6A), // Green
      const Color(0xFF42A5F5), // Blue
      const Color(0xFFAB47BC), // Purple
      const Color(0xFFEF5350), // Red
      const Color(0xFF26C6DA), // Cyan
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final parsedData = jsonDecode(dietPlanJson);
    final plans = parsedData['plans'] as Map<String, dynamic>;

    // Match user's motivation to a plan key
    String userGoal = GymUserData().motivation;
    String planKey = 'Keep Fit'; // default
    for (var key in plans.keys) {
      if (userGoal.toLowerCase().contains(key.toLowerCase()) || 
          key.toLowerCase().contains(userGoal.toLowerCase())) {
        planKey = key;
        break;
      }
    }
    if (userGoal.toLowerCase().contains('lose') || userGoal.toLowerCase().contains('weight')) {
      planKey = 'Lose Weight';
    } else if (userGoal.toLowerCase().contains('muscle') || userGoal.toLowerCase().contains('build')) {
      planKey = 'Build Muscle';
    }

    final plan = plans[planKey];
    final meals = plan['meals'] as List<dynamic>;
    final tips = plan['tips'] as List<dynamic>;
    int dailyCal = plan['daily_calories'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Diet Plan',
          style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    planKey == 'Lose Weight'
                        ? const Color(0xFFFF7043)
                        : planKey == 'Build Muscle'
                            ? const Color(0xFF5C6BC0)
                            : const Color(0xFF43A047),
                    planKey == 'Lose Weight'
                        ? const Color(0xFFFF9800)
                        : planKey == 'Build Muscle'
                            ? const Color(0xFF7986CB)
                            : const Color(0xFF66BB6A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.restaurant_menu, color: Colors.white, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan['title'],
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              plan['subtitle'],
                              style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatChip('$dailyCal', 'Daily Kcal', Icons.local_fire_department),
                      const SizedBox(width: 12),
                      _buildStatChip('${meals.length}', 'Meals/Day', Icons.restaurant),
                    ],
                  ),
                ],
              ),
            ),

            // Meals
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Daily Meals',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),

            ...meals.asMap().entries.map((entry) {
              int idx = entry.key;
              final meal = entry.value;
              final items = meal['items'] as List<dynamic>;
              Color color = _getMealColor(idx);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Meal Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_getMealIcon(meal['icon']), color: color, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meal['type'],
                                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                                ),
                                Text(
                                  meal['time'],
                                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${items.fold(0, (sum, item) => sum + (item['calories'] as int))} kcal',
                            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: color),
                          ),
                        ],
                      ),
                    ),
                    // Food Items
                    ...items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item['name'],
                              style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
                            ),
                          ),
                          Text(
                            '${item['calories']} cal',
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${item['protein']}g P',
                              style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF3B82F6)),
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            // Tips Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Nutrition Tips',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
              ),
            ),
            const SizedBox(height: 12),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF43A047), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      tip,
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
