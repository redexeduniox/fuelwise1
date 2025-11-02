class FoodItem {
  final String name;
  final int calories; // per serving
  final double protein; // grams
  final double carbs; // grams
  final double fats; // grams
  final String? category;

  const FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.category,
  });
}
