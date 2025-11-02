class DailySummary {
  final DateTime date;
  final int totalCalories;
  final double protein;
  final double carbs;
  final double fats;

  const DailySummary({
    required this.date,
    required this.totalCalories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });
}
