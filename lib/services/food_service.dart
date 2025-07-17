import '../models/food_entry.dart';

class FoodService {
  static final List<MealEntry> _mealEntries = [];

  static Future<List<FoodEntry>> getFoodDatabase() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      FoodEntry(
        id: '1',
        name: 'Banana',
        category: 'Fruits',
        calories: 105,
        protein: 1.3,
        carbs: 27.0,
        fat: 0.4,
        fiber: 3.1,
        servingSize: '1 medium (118g)',
      ),
      FoodEntry(
        id: '2',
        name: 'Chicken Breast',
        category: 'Protein',
        calories: 165,
        protein: 31.0,
        carbs: 0.0,
        fat: 3.6,
        fiber: 0.0,
        servingSize: '100g',
      ),
      FoodEntry(
        id: '3',
        name: 'Brown Rice',
        category: 'Grains',
        calories: 216,
        protein: 5.0,
        carbs: 45.0,
        fat: 1.8,
        fiber: 3.5,
        servingSize: '1 cup cooked (195g)',
      ),
      FoodEntry(
        id: '4',
        name: 'Greek Yogurt',
        category: 'Dairy',
        calories: 100,
        protein: 17.0,
        carbs: 6.0,
        fat: 0.7,
        fiber: 0.0,
        servingSize: '170g container',
      ),
      FoodEntry(
        id: '5',
        name: 'Avocado',
        category: 'Fruits',
        calories: 234,
        protein: 2.9,
        carbs: 12.0,
        fat: 21.0,
        fiber: 10.0,
        servingSize: '1 medium (150g)',
      ),
      FoodEntry(
        id: '6',
        name: 'Almonds',
        category: 'Nuts',
        calories: 164,
        protein: 6.0,
        carbs: 6.0,
        fat: 14.0,
        fiber: 3.5,
        servingSize: '28g (23 almonds)',
      ),
      FoodEntry(
        id: '7',
        name: 'Spinach',
        category: 'Vegetables',
        calories: 7,
        protein: 0.9,
        carbs: 1.1,
        fat: 0.1,
        fiber: 0.7,
        servingSize: '30g (1 cup)',
      ),
      FoodEntry(
        id: '8',
        name: 'Salmon',
        category: 'Protein',
        calories: 208,
        protein: 22.0,
        carbs: 0.0,
        fat: 12.0,
        fiber: 0.0,
        servingSize: '100g',
      ),
    ];
  }

  static Future<List<FoodEntry>> searchFood(String query) async {
    final allFoods = await getFoodDatabase();
    if (query.isEmpty) return allFoods;
    
    return allFoods.where((food) => 
      food.name.toLowerCase().contains(query.toLowerCase()) ||
      food.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  static Future<void> addMealEntry(MealEntry meal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mealEntries.add(meal);
  }

  static Future<List<MealEntry>> getMealEntries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mealEntries);
  }

  static Future<List<MealEntry>> getMealEntriesForDate(DateTime date) async {
    final allMeals = await getMealEntries();
    return allMeals.where((meal) => 
      meal.date.year == date.year &&
      meal.date.month == date.month &&
      meal.date.day == date.day
    ).toList();
  }

  static Future<Map<String, int>> getTodayNutrition() async {
    final today = DateTime.now();
    final todayMeals = await getMealEntriesForDate(today);
    
    int totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var meal in todayMeals) {
      totalCalories += meal.totalCalories;
      totalProtein += meal.totalProtein;
      totalCarbs += meal.totalCarbs;
      totalFat += meal.totalFat;
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein.round(),
      'carbs': totalCarbs.round(),
      'fat': totalFat.round(),
    };
  }

  static Future<int> getCaloriesThisWeek() async {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final allMeals = await getMealEntries();
    
    return allMeals
        .where((meal) => meal.date.isAfter(weekAgo))
        .fold<int>(0, (sum, meal) => sum + (meal.totalCalories));
  }
}
