import 'package:flutter/foundation.dart';

enum MealType { breakfast, lunch, snack, dinner }

class DietMeal {
  final String id;
  final String name;
  final MealType type;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  bool isCompleted;

  DietMeal({
    required this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.isCompleted = false,
  });

  DietMeal copyWith({bool? isCompleted}) {
    return DietMeal(
      id: id,
      name: name,
      type: type,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fats: fats,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class DailyDietPlan {
  final DateTime date;
  final List<DietMeal> meals;
  final int targetCalories;

  DailyDietPlan({
    required this.date,
    required this.meals,
    required this.targetCalories,
  });

  int get consumedCalories =>
      meals.where((m) => m.isCompleted).fold(0, (sum, m) => sum + m.calories);

  int get consumedProtein =>
      meals.where((m) => m.isCompleted).fold(0, (sum, m) => sum + m.protein);

  int get consumedCarbs =>
      meals.where((m) => m.isCompleted).fold(0, (sum, m) => sum + m.carbs);

  int get consumedFats =>
      meals.where((m) => m.isCompleted).fold(0, (sum, m) => sum + m.fats);
      
  bool get isDayCompleted => meals.every((m) => m.isCompleted);
}
