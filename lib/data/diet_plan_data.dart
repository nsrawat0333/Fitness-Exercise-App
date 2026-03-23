const String dietPlanJson = '''
{
  "plans": {
    "Lose Weight": {
      "title": "Weight Loss Diet Plan",
      "subtitle": "Caloric deficit with balanced nutrition",
      "daily_calories": 1800,
      "meals": [
        {
          "type": "Breakfast",
          "time": "7:00 AM",
          "icon": "breakfast_dining",
          "items": [
            {"name": "Oatmeal with berries", "calories": 250, "protein": 8},
            {"name": "Green tea (no sugar)", "calories": 5, "protein": 0},
            {"name": "Boiled eggs (2)", "calories": 155, "protein": 13}
          ]
        },
        {
          "type": "Mid-Morning Snack",
          "time": "10:00 AM",
          "icon": "apple",
          "items": [
            {"name": "Apple + Almonds (10)", "calories": 160, "protein": 4},
            {"name": "Lemon water", "calories": 10, "protein": 0}
          ]
        },
        {
          "type": "Lunch",
          "time": "1:00 PM",
          "icon": "lunch_dining",
          "items": [
            {"name": "Grilled chicken salad", "calories": 350, "protein": 30},
            {"name": "Brown rice (1/2 cup)", "calories": 110, "protein": 3},
            {"name": "Mixed vegetables", "calories": 80, "protein": 3}
          ]
        },
        {
          "type": "Evening Snack",
          "time": "4:00 PM",
          "icon": "cookie",
          "items": [
            {"name": "Greek yogurt", "calories": 100, "protein": 10},
            {"name": "Mixed nuts (small)", "calories": 90, "protein": 3}
          ]
        },
        {
          "type": "Dinner",
          "time": "7:30 PM",
          "icon": "dinner_dining",
          "items": [
            {"name": "Grilled fish/tofu", "calories": 200, "protein": 22},
            {"name": "Steamed broccoli", "calories": 55, "protein": 4},
            {"name": "Soup (clear)", "calories": 80, "protein": 5}
          ]
        }
      ],
      "tips": [
        "Drink 3-4 liters of water daily",
        "Avoid sugar and processed foods",
        "Eat slowly and mindfully",
        "No eating after 8 PM"
      ]
    },
    "Build Muscle": {
      "title": "Muscle Building Diet Plan",
      "subtitle": "High protein for muscle growth",
      "daily_calories": 2800,
      "meals": [
        {
          "type": "Breakfast",
          "time": "7:00 AM",
          "icon": "breakfast_dining",
          "items": [
            {"name": "Egg omelette (4 eggs)", "calories": 380, "protein": 26},
            {"name": "Whole wheat toast (2)", "calories": 180, "protein": 8},
            {"name": "Banana shake + whey", "calories": 350, "protein": 30}
          ]
        },
        {
          "type": "Mid-Morning Snack",
          "time": "10:30 AM",
          "icon": "apple",
          "items": [
            {"name": "Peanut butter sandwich", "calories": 320, "protein": 12},
            {"name": "Mixed dry fruits", "calories": 180, "protein": 5}
          ]
        },
        {
          "type": "Lunch",
          "time": "1:00 PM",
          "icon": "lunch_dining",
          "items": [
            {"name": "Chicken breast (200g)", "calories": 330, "protein": 62},
            {"name": "White rice (1 cup)", "calories": 200, "protein": 4},
            {"name": "Dal / Lentils", "calories": 150, "protein": 10}
          ]
        },
        {
          "type": "Pre-Workout Snack",
          "time": "4:00 PM",
          "icon": "cookie",
          "items": [
            {"name": "Banana + honey", "calories": 140, "protein": 2},
            {"name": "Black coffee", "calories": 5, "protein": 0}
          ]
        },
        {
          "type": "Post-Workout",
          "time": "6:30 PM",
          "icon": "sports",
          "items": [
            {"name": "Whey protein shake", "calories": 250, "protein": 25},
            {"name": "Dates (5)", "calories": 115, "protein": 1}
          ]
        },
        {
          "type": "Dinner",
          "time": "8:30 PM",
          "icon": "dinner_dining",
          "items": [
            {"name": "Paneer / Cottage cheese", "calories": 250, "protein": 18},
            {"name": "Chapati (2)", "calories": 200, "protein": 6},
            {"name": "Mixed veg curry", "calories": 120, "protein": 4}
          ]
        }
      ],
      "tips": [
        "Eat every 2-3 hours",
        "1.5g protein per kg bodyweight",
        "Stay hydrated (4+ liters)",
        "Sleep 7-8 hours for recovery"
      ]
    },
    "Keep Fit": {
      "title": "Stay Fit Diet Plan",
      "subtitle": "Balanced nutrition for active lifestyle",
      "daily_calories": 2200,
      "meals": [
        {
          "type": "Breakfast",
          "time": "7:30 AM",
          "icon": "breakfast_dining",
          "items": [
            {"name": "Muesli with milk", "calories": 280, "protein": 10},
            {"name": "Fresh fruit juice", "calories": 120, "protein": 1},
            {"name": "Boiled egg (1)", "calories": 78, "protein": 6}
          ]
        },
        {
          "type": "Mid-Morning Snack",
          "time": "10:30 AM",
          "icon": "apple",
          "items": [
            {"name": "Fresh fruits", "calories": 100, "protein": 1},
            {"name": "Green tea", "calories": 5, "protein": 0}
          ]
        },
        {
          "type": "Lunch",
          "time": "1:00 PM",
          "icon": "lunch_dining",
          "items": [
            {"name": "Grilled chicken/paneer", "calories": 300, "protein": 25},
            {"name": "Brown rice", "calories": 160, "protein": 4},
            {"name": "Salad + vegetables", "calories": 100, "protein": 3}
          ]
        },
        {
          "type": "Evening Snack",
          "time": "4:30 PM",
          "icon": "cookie",
          "items": [
            {"name": "Sprouts / trail mix", "calories": 150, "protein": 8},
            {"name": "Buttermilk / lassi", "calories": 60, "protein": 3}
          ]
        },
        {
          "type": "Dinner",
          "time": "8:00 PM",
          "icon": "dinner_dining",
          "items": [
            {"name": "Fish / Tofu stir-fry", "calories": 250, "protein": 22},
            {"name": "Multigrain roti (2)", "calories": 180, "protein": 6},
            {"name": "Light soup", "calories": 80, "protein": 4}
          ]
        }
      ],
      "tips": [
        "Eat more whole foods, less processed",
        "Stay consistent with meals",
        "Hydrate well throughout the day",
        "Include variety of fruits & vegetables"
      ]
    }
  }
}
''';
