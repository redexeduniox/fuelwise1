import 'package:flutter/material.dart';
import 'package:fuelwise/models/food_entry.dart';

class FoodEntryCard extends StatelessWidget {
  final FoodEntry entry;
  final VoidCallback onDelete;

  const FoodEntryCard({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildNutrientTag('P: ${entry.protein.toStringAsFixed(1)}g', const Color(0xFFFF6B9D)),
                    const SizedBox(width: 6),
                    _buildNutrientTag('C: ${entry.carbs.toStringAsFixed(1)}g', const Color(0xFFFFA726)),
                    const SizedBox(width: 6),
                    _buildNutrientTag('F: ${entry.fats.toStringAsFixed(1)}g', const Color(0xFF00D9A5)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${entry.calories}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF))),
              const Text('cal', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(Icons.delete_outline, color: Colors.red[400], size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
    );
  }
}
