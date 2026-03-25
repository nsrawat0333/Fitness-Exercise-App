import 'package:flutter/material.dart';
import '../models/diet_models.dart';
import 'diet_ml_service.dart';

class DietStateService extends ChangeNotifier {
  // Mock User State (This would normally come from User/Auth Service)
  double userWeightKg = 70.0;
  int userBodyType = 1; // 0=Lean, 1=Fit, 2=Fat
  int consecutiveDaysLogged = 0;

  // Real-time Plan
  DailyDietPlan? currentDayPlan;
  List<DailyDietPlan> dietHistory = [];

  // Current Dynamic Target Constraints
  int currentTargetCalories = 2000;

  DietStateService() {
    _generateDefaultDatasetPlan();
  }

  void setBodyType(int typeIndex) {
    userBodyType = typeIndex;
    _generateDefaultDatasetPlan();
  }

  // Uses Kaggle Diet Recommendation structural defaults
  void _generateDefaultDatasetPlan() {
    List<DietMeal> defaultMeals = [];

    if (userBodyType == 0) {
      // LEAN -> Muscle Gain Surplus
      currentTargetCalories = 2400;
      defaultMeals = [
        DietMeal(id: '1', name: '4 Whole Eggs + 1 Glass Whole Milk', type: MealType.breakfast, calories: 450, protein: 32, carbs: 12, fats: 30),
        DietMeal(id: '2', name: '2 Bananas + Peanut Butter', type: MealType.snack, calories: 350, protein: 10, carbs: 55, fats: 16),
        DietMeal(id: '3', name: 'Chicken Breast (200g) + White Rice (1 cup)', type: MealType.lunch, calories: 550, protein: 50, carbs: 45, fats: 8),
        DietMeal(id: '4', name: 'Greek Yogurt + Almonds', type: MealType.snack, calories: 250, protein: 15, carbs: 10, fats: 18),
        DietMeal(id: '5', name: 'Paneer (150g) + 3 Roti + Veggies', type: MealType.dinner, calories: 600, protein: 28, carbs: 65, fats: 25),
      ];
    } else if (userBodyType == 2) {
      // FAT -> Fat Loss Deficit
      currentTargetCalories = 1600;
      defaultMeals = [
        DietMeal(id: '1', name: 'Oats (50g) + Berries + Black Coffee', type: MealType.breakfast, calories: 250, protein: 8, carbs: 45, fats: 5),
        DietMeal(id: '2', name: 'Green Tea + 1 Apple', type: MealType.snack, calories: 100, protein: 1, carbs: 25, fats: 0),
        DietMeal(id: '3', name: 'Yellow Dal (1 bowl) + Brown Rice (0.5 cup) + Cucumber Salad', type: MealType.lunch, calories: 350, protein: 18, carbs: 55, fats: 6),
        DietMeal(id: '4', name: 'Roasted Makhana (Fox Nuts)', type: MealType.snack, calories: 120, protein: 3, carbs: 20, fats: 2),
        DietMeal(id: '5', name: 'Grilled Fish/Tofu (150g) + Steamed Broccoli', type: MealType.dinner, calories: 300, protein: 35, carbs: 10, fats: 12),
      ];
    } else {
      // FIT -> Balanced Maintenance
      currentTargetCalories = 2000;
      defaultMeals = [
        DietMeal(id: '1', name: '2 Scrambled Eggs + 2 Whole Wheat Toast', type: MealType.breakfast, calories: 350, protein: 18, carbs: 30, fats: 15),
        DietMeal(id: '2', name: 'Mixed Fruits', type: MealType.snack, calories: 150, protein: 2, carbs: 35, fats: 1),
        DietMeal(id: '3', name: 'Chicken/Soy Chunks Khichdi + Curd', type: MealType.lunch, calories: 500, protein: 30, carbs: 65, fats: 12),
        DietMeal(id: '4', name: 'Protein Shake OR Sprouts Salad', type: MealType.snack, calories: 200, protein: 24, carbs: 15, fats: 3),
        DietMeal(id: '5', name: 'Mixed Veg Curry + 2 Roti', type: MealType.dinner, calories: 450, protein: 12, carbs: 60, fats: 15),
      ];
    }

    currentDayPlan = DailyDietPlan(
      date: DateTime.now(),
      meals: defaultMeals,
      targetCalories: currentTargetCalories,
    );
    notifyListeners();
  }

  void toggleMealCompletion(String mealId, bool isCompleted) {
    if (currentDayPlan == null) return;

    final mealIndex = currentDayPlan!.meals.indexWhere((m) => m.id == mealId);
    if (mealIndex != -1) {
      currentDayPlan!.meals[mealIndex].isCompleted = isCompleted;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------
  // THE TFLITE AI PROGRESSIVE OVERLOAD SYSTEM
  // -------------------------------------------------------------
  void logDayAndRunAI() async {
    if (currentDayPlan == null) return;
    
    // Save to history
    dietHistory.add(currentDayPlan!);
    consecutiveDaysLogged++;

    // Calculate actual consumed intake
    double consumedKcal = currentDayPlan!.consumedCalories.toDouble();

    // Consult AI Model for Tomorrow's Target
    // The ML model dynamically provides a strict target delta to safely push you to your goal without extremes.
    double modelDelta = DietMLService.predictCalorieAdjustment(
      currentCalories: consumedKcal,
      weightKg: userWeightKg,
      bodyType: userBodyType,
      daysLogged: consecutiveDaysLogged,
    );

    // Apply strict physical limitations mathematically
    int roundedDelta = modelDelta.round();
    
    // Update Tomorrow's Goals
    currentTargetCalories += roundedDelta;
    
    // Hard clamp to prevent starvation or binge values
    if (userBodyType == 2) currentTargetCalories = currentTargetCalories.clamp(1400, 2500); // Max restriction
    if (userBodyType == 0) currentTargetCalories = currentTargetCalories.clamp(2000, 3500); // Max bulking
    if (userBodyType == 1) currentTargetCalories = currentTargetCalories.clamp(1800, 2800); // Maintenance bounds

    // Reset UI checklist for the next day, maintaining new target properties
    _resetListForNextDay();
  }

  void _resetListForNextDay() {
    if (currentDayPlan == null) return;
    final nextDate = currentDayPlan!.date.add(const Duration(days: 1));
    
    // Uncheck everything
    final newMeals = currentDayPlan!.meals.map((m) => m.copyWith(isCompleted: false)).toList();

    currentDayPlan = DailyDietPlan(
      date: nextDate,
      meals: newMeals,
      targetCalories: currentTargetCalories,
    );

    notifyListeners();
  }
}
