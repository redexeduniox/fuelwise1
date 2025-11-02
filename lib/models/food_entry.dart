class FoodEntry {
  final String id;
  final String userId;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final String mealType;
  final DateTime createdAt;
  final DateTime updatedAt;

  FoodEntry({
    required this.id,
    required this.userId,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.mealType,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fats': fats,
    'mealType': mealType,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory FoodEntry.fromJson(Map<String, dynamic> json) => FoodEntry(
    id: json['id'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    calories: json['calories'] as int,
    protein: (json['protein'] as num).toDouble(),
    carbs: (json['carbs'] as num).toDouble(),
    fats: (json['fats'] as num).toDouble(),
    mealType: json['mealType'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  FoodEntry copyWith({
    String? id,
    String? userId,
    String? name,
    int? calories,
    double? protein,
    double? carbs,
    double? fats,
    String? mealType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FoodEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fats: fats ?? this.fats,
    mealType: mealType ?? this.mealType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
