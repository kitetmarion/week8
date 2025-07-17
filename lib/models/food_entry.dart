class FoodEntry {
  final String id;
  final String name;
  final String category;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final String servingSize;

  FoodEntry({
    required this.id,
    required this.name,
    required this.category,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.servingSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'servingSize': servingSize,
    };
  }

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      calories: json['calories'],
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      fiber: json['fiber'].toDouble(),
      servingSize: json['servingSize'],
    );
  }
}

class MealEntry {
  final String id;
  final DateTime date;
  final String mealType; // breakfast, lunch, dinner, snack
  final List<FoodEntryWithQuantity> foods;
  final String notes;

  MealEntry({
    required this.id,
    required this.date,
    required this.mealType,
    required this.foods,
    this.notes = '',
  });

  int get totalCalories {
    return foods.fold(0, (sum, food) => sum + (food.foodEntry.calories * food.quantity).round());
  }

  double get totalProtein {
    return foods.fold(0.0, (sum, food) => sum + (food.foodEntry.protein * food.quantity));
  }

  double get totalCarbs {
    return foods.fold(0.0, (sum, food) => sum + (food.foodEntry.carbs * food.quantity));
  }

  double get totalFat {
    return foods.fold(0.0, (sum, food) => sum + (food.foodEntry.fat * food.quantity));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mealType': mealType,
      'foods': foods.map((f) => f.toJson()).toList(),
      'notes': notes,
    };
  }

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      mealType: json['mealType'],
      foods: (json['foods'] as List).map((f) => FoodEntryWithQuantity.fromJson(f)).toList(),
      notes: json['notes'] ?? '',
    );
  }
}

class FoodEntryWithQuantity {
  final FoodEntry foodEntry;
  final double quantity;

  FoodEntryWithQuantity({
    required this.foodEntry,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'foodEntry': foodEntry.toJson(),
      'quantity': quantity,
    };
  }

  factory FoodEntryWithQuantity.fromJson(Map<String, dynamic> json) {
    return FoodEntryWithQuantity(
      foodEntry: FoodEntry.fromJson(json['foodEntry']),
      quantity: json['quantity'].toDouble(),
    );
  }
}
