import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/food_entry.dart';
import 'firebase_service.dart';

class FoodService {
  static final FirebaseFirestore _firestore = FirebaseService.firestore;
  static final FirebaseAuth _auth = FirebaseService.auth;

  // Get food database (predefined foods)
  static Future<List<FoodEntry>> getFoodDatabase() async {
    try {
      // For now, return predefined foods. In production, these could be stored in Firestore
      return _getPredefinedFoods();
    } catch (e) {
      print('Error getting food database: $e');
      return _getPredefinedFoods();
    }
  }

  static List<FoodEntry> _getPredefinedFoods() {
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
      FoodEntry(
        id: '9',
        name: 'Sweet Potato',
        category: 'Vegetables',
        calories: 112,
        protein: 2.0,
        carbs: 26.0,
        fat: 0.1,
        fiber: 3.9,
        servingSize: '1 medium (128g)',
      ),
      FoodEntry(
        id: '10',
        name: 'Oatmeal',
        category: 'Grains',
        calories: 154,
        protein: 5.3,
        carbs: 28.0,
        fat: 3.2,
        fiber: 4.0,
        servingSize: '1 cup cooked (234g)',
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

  // Save meal entry to Firebase
  static Future<bool> addMealEntry(MealEntry meal) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      Map<String, dynamic> mealData = {
        'date': Timestamp.fromDate(meal.date),
        'mealType': meal.mealType,
        'foods': meal.foods.map((f) => {
          'foodEntry': f.foodEntry.toJson(),
          'quantity': f.quantity,
        }).toList(),
        'notes': meal.notes,
        'totalCalories': meal.totalCalories,
        'totalProtein': meal.totalProtein,
        'totalCarbs': meal.totalCarbs,
        'totalFat': meal.totalFat,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseService.getUserFoodEntries(currentUser.uid).add(mealData);
      return true;
    } catch (e) {
      print('Error adding meal entry: $e');
      return false;
    }
  }

  // Get user's meal entries from Firebase
  static Future<List<MealEntry>> getMealEntries() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      QuerySnapshot snapshot = await FirebaseService.getUserFoodEntries(currentUser.uid)
          .orderBy('date', descending: true)
          .limit(100)
          .get();

      List<MealEntry> meals = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        List<FoodEntryWithQuantity> foods = [];
        if (data['foods'] != null) {
          for (var foodData in data['foods']) {
            foods.add(FoodEntryWithQuantity(
              foodEntry: FoodEntry.fromJson(foodData['foodEntry']),
              quantity: foodData['quantity'].toDouble(),
            ));
          }
        }

        meals.add(MealEntry(
          id: doc.id,
          date: (data['date'] as Timestamp).toDate(),
          mealType: data['mealType'],
          foods: foods,
          notes: data['notes'] ?? '',
        ));
      }

      return meals;
    } catch (e) {
      print('Error getting meal entries: $e');
      return [];
    }
  }

  static Future<List<MealEntry>> getMealEntriesForDate(DateTime date) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      // Create start and end of day timestamps
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      QuerySnapshot snapshot = await FirebaseService.getUserFoodEntries(currentUser.uid)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('date')
          .get();

      List<MealEntry> meals = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        List<FoodEntryWithQuantity> foods = [];
        if (data['foods'] != null) {
          for (var foodData in data['foods']) {
            foods.add(FoodEntryWithQuantity(
              foodEntry: FoodEntry.fromJson(foodData['foodEntry']),
              quantity: foodData['quantity'].toDouble(),
            ));
          }
        }

        meals.add(MealEntry(
          id: doc.id,
          date: (data['date'] as Timestamp).toDate(),
          mealType: data['mealType'],
          foods: foods,
          notes: data['notes'] ?? '',
        ));
      }

      return meals;
    } catch (e) {
      print('Error getting meal entries for date: $e');
      return [];
    }
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
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return 0;

      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      
      QuerySnapshot snapshot = await FirebaseService.getUserFoodEntries(currentUser.uid)
          .where('date', isGreaterThan: Timestamp.fromDate(weekAgo))
          .get();

      int totalCalories = 0;
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        totalCalories += (data['totalCalories'] as int? ?? 0);
      }

      return totalCalories;
    } catch (e) {
      print('Error getting calories this week: $e');
      return 0;
    }
  }

  // Delete meal entry
  static Future<bool> deleteMealEntry(String mealId) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await FirebaseService.getUserFoodEntries(currentUser.uid).doc(mealId).delete();
      return true;
    } catch (e) {
      print('Error deleting meal entry: $e');
      return false;
    }
  }

  // Update meal entry
  static Future<bool> updateMealEntry(MealEntry meal) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      Map<String, dynamic> mealData = {
        'date': Timestamp.fromDate(meal.date),
        'mealType': meal.mealType,
        'foods': meal.foods.map((f) => {
          'foodEntry': f.foodEntry.toJson(),
          'quantity': f.quantity,
        }).toList(),
        'notes': meal.notes,
        'totalCalories': meal.totalCalories,
        'totalProtein': meal.totalProtein,
        'totalCarbs': meal.totalCarbs,
        'totalFat': meal.totalFat,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseService.getUserFoodEntries(currentUser.uid).doc(meal.id).update(mealData);
      return true;
    } catch (e) {
      print('Error updating meal entry: $e');
      return false;
    }
  }
}