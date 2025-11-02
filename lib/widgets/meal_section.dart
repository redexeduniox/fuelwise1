import 'package:flutter/material.dart';
import 'package:fuelwise/models/food_entry.dart';
import 'package:fuelwise/widgets/food_entry_card.dart';

class MealSection extends StatelessWidget {
  final String title;
  final List<FoodEntry> entries;
  final Function(String) onDelete;

  const MealSection({
    super.key,
    required this.title,
    required this.entries,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final totalCalories = entries.fold<int>(0, (sum, entry) => sum + entry.calories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
            if (entries.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$totalCalories cal', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6C63FF))),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (entries.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Center(
              child: Text('No items added', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ),
          )
        else
          ...entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FoodEntryCard(entry: entry, onDelete: () => onDelete(entry.id)),
          )),
      ],
    );
  }
}
