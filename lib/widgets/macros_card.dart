import 'package:flutter/material.dart';

class MacrosCard extends StatelessWidget {
  final Map<String, double> macros;

  const MacrosCard({super.key, required this.macros});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Macronutrients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroItem('Protein', macros['protein'] ?? 0, const Color(0xFFFF6B9D)),
              _buildMacroItem('Carbs', macros['carbs'] ?? 0, const Color(0xFFFFA726)),
              _buildMacroItem('Fats', macros['fats'] ?? 0, const Color(0xFF00D9A5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, double value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          children: [
            Text('${value.toStringAsFixed(1)}g', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }
}
