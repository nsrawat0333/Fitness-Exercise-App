import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/diet_models.dart';
import '../../services/diet_state_service.dart';

class DietPlannerScreen extends StatelessWidget {
  const DietPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DietStateService(),
      child: const _DietPlannerView(),
    );
  }
}

class _DietPlannerView extends StatelessWidget {
  const _DietPlannerView();

  @override
  Widget build(BuildContext context) {
    final dietState = context.watch<DietStateService>();
    final plan = dietState.currentDayPlan;

    if (plan == null) {
      return const Scaffold(
        backgroundColor: AppColors.sageDark,
        body: Center(child: CircularProgressIndicator(color: AppColors.sageGreen)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Deep Premium Dark Mode
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "AI Diet Planner",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () => _showBodyTypeDialog(context, dietState),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCaloriesWidget(plan),
              const SizedBox(height: 24),
              _buildMacroGrid(plan),
              const SizedBox(height: 24),
              Text(
                "Today's Smart Meals",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildMealList(context, plan.meals, dietState),
              const SizedBox(height: 32),
              
              if (plan.isDayCompleted)
                _buildCompleteDayButton(context, dietState),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Custom meals coming soon!")),
          );
        },
        backgroundColor: AppColors.sageGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showBodyTypeDialog(BuildContext context, DietStateService state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text("Select Body Type", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Lean (Muscle Gain)", style: TextStyle(color: Colors.white70)),
              leading: Radio(value: 0, groupValue: state.userBodyType, onChanged: (v) { state.setBodyType(0); Navigator.pop(ctx); }),
            ),
            ListTile(
              title: const Text("Fit (Maintain Balance)", style: TextStyle(color: Colors.white70)),
              leading: Radio(value: 1, groupValue: state.userBodyType, onChanged: (v) { state.setBodyType(1); Navigator.pop(ctx); }),
            ),
            ListTile(
              title: const Text("Fat (Fat Loss Deficit)", style: TextStyle(color: Colors.white70)),
              leading: Radio(value: 2, groupValue: state.userBodyType, onChanged: (v) { state.setBodyType(2); Navigator.pop(ctx); }),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildCaloriesWidget(DailyDietPlan plan) {
    int remaining = plan.targetCalories - plan.consumedCalories;
    double progress = (plan.consumedCalories / plan.targetCalories).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Calories Left",
                style: GoogleFonts.inter(
                  color: Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.local_fire_department, color: AppColors.sageGreen, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                remaining.toString(),
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "kcal",
                  style: GoogleFonts.inter(
                    color: Colors.white54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0 ? Colors.redAccent : AppColors.sageGreen),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${plan.consumedCalories} Eaten", style: const TextStyle(color: Colors.white54, fontSize: 13)),
              Text("${plan.targetCalories} Target", style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMacroGrid(DailyDietPlan plan) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMacroRing("Protein", plan.consumedProtein, 150, Colors.blueAccent),
        _buildMacroRing("Carbs", plan.consumedCarbs, 200, Colors.orangeAccent),
        _buildMacroRing("Fats", plan.consumedFats, 60, Colors.redAccent),
      ],
    );
  }

  Widget _buildMacroRing(String title, int consumed, int target, Color color) {
    double pct = (consumed / target).clamp(0.0, 1.0);
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: pct,
                  strokeWidth: 6,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Center(
                  child: Text(
                    "${(pct * 100).toInt()}%",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("${consumed}g", style: const TextStyle(color: Colors.white34, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildMealList(BuildContext context, List<DietMeal> meals, DietStateService state) {
    return Column(
      children: meals.map((meal) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: meal.isCompleted ? const Color(0xFF161616) : const Color(0xFF222222),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: meal.isCompleted ? AppColors.sageGreen.withOpacity(0.5) : Colors.transparent),
          ),
          child: CheckboxListTile(
            value: meal.isCompleted,
            activeColor: AppColors.sageGreen,
            checkColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onChanged: (val) {
              if (val != null) state.toggleMealCompletion(meal.id, val);
            },
            title: Text(
              meal.name,
              style: GoogleFonts.inter(
                color: meal.isCompleted ? Colors.white54 : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: meal.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  _MacroBadge(text: "${meal.calories} kcal", color: Colors.grey.shade800),
                  const SizedBox(width: 8),
                  _MacroBadge(text: "${meal.protein}g P", color: Colors.blue.withOpacity(0.3)),
                  const SizedBox(width: 8),
                  _MacroBadge(text: "${meal.carbs}g C", color: Colors.orange.withOpacity(0.3)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompleteDayButton(BuildContext context, DietStateService state) {
    return InkWell(
      onTap: () {
        state.logDayAndRunAI();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Day Logged Successfully! the AI formulated tomorrow's dynamic target 🧠"),
            backgroundColor: AppColors.sageGreen,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF388E3C), Color(0xFF66BB6A)],
          ),
        ),
        child: Center(
          child: Text(
            "Finish Day & Evaluate AI Routine",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  final String text;
  final Color color;
  const _MacroBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
