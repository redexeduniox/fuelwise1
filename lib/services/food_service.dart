import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fuelwise/models/food_entry.dart';
import 'package:fuelwise/models/daily_summary.dart';

class FoodService {
  static const String _entriesKey = 'food_entries';

  Future<void> _initializeSampleData() async {
    final entries = await getAllEntries();
    if (entries.isEmpty) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final sampleEntries = [
        FoodEntry(
          id: '1',
          userId: '1',
          name: 'Avocado Toast',
          calories: 320,
          protein: 12,
          carbs: 35,
          fats: 18,
          mealType: 'Breakfast',
          createdAt: today.add(const Duration(hours: 8)),
          updatedAt: today.add(const Duration(hours: 8)),
        ),
        FoodEntry(
          id: '2',
          userId: '1',
          name: 'Greek Yogurt with Berries',
          calories: 180,
          protein: 15,
          carbs: 22,
          fats: 4,
          mealType: 'Breakfast',
          createdAt: today.add(const Duration(hours: 8, minutes: 30)),
          updatedAt: today.add(const Duration(hours: 8, minutes: 30)),
        ),
        FoodEntry(
          id: '3',
          userId: '1',
          name: 'Grilled Chicken Salad',
          calories: 450,
          protein: 42,
          carbs: 28,
          fats: 18,
          mealType: 'Lunch',
          createdAt: today.add(const Duration(hours: 13)),
          updatedAt: today.add(const Duration(hours: 13)),
        ),
        FoodEntry(
          id: '4',
          userId: '1',
          name: 'Protein Smoothie',
          calories: 280,
          protein: 25,
          carbs: 32,
          fats: 6,
          mealType: 'Snack',
          createdAt: today.add(const Duration(hours: 16)),
          updatedAt: today.add(const Duration(hours: 16)),
        ),
      ];
      
      for (var entry in sampleEntries) {
        await addEntry(entry);
      }
    }
  }

  Future<List<FoodEntry>> getAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList(_entriesKey) ?? [];
    return entriesJson.map((e) => FoodEntry.fromJson(json.decode(e))).toList();
  }

  Future<List<FoodEntry>> getEntriesByDate(DateTime date) async {
    await _initializeSampleData();
    final allEntries = await getAllEntries();
    final targetDate = DateTime(date.year, date.month, date.day);
    return allEntries.where((entry) {
      final entryDate = DateTime(entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);
      return entryDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  Future<void> addEntry(FoodEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getAllEntries();
    entries.add(entry);
    final entriesJson = entries.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_entriesKey, entriesJson);
  }

  Future<void> deleteEntry(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getAllEntries();
    entries.removeWhere((e) => e.id == id);
    final entriesJson = entries.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_entriesKey, entriesJson);
  }

  Future<int> getTotalCaloriesToday() async {
    final entries = await getEntriesByDate(DateTime.now());
    return entries.fold<int>(0, (sum, entry) => sum + entry.calories);
  }

  Future<Map<String, double>> getMacronutrientsToday() async {
    final entries = await getEntriesByDate(DateTime.now());
    return {
      'protein': entries.fold<double>(0.0, (sum, entry) => sum + entry.protein),
      'carbs': entries.fold<double>(0.0, (sum, entry) => sum + entry.carbs),
      'fats': entries.fold<double>(0.0, (sum, entry) => sum + entry.fats),
    };
  }

  Future<List<DailySummary>> getDailySummaries({int? limit}) async {
    await _initializeSampleData();
    final all = await getAllEntries();
    final Map<DateTime, List<FoodEntry>> byDate = {};

    for (final e in all) {
      final d = DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day);
      byDate.putIfAbsent(d, () => []).add(e);
    }

    final summaries = byDate.entries.map((entry) {
      final list = entry.value;
      final calories = list.fold<int>(0, (sum, e) => sum + e.calories);
      final protein = list.fold<double>(0.0, (sum, e) => sum + e.protein);
      final carbs = list.fold<double>(0.0, (sum, e) => sum + e.carbs);
      final fats = list.fold<double>(0.0, (sum, e) => sum + e.fats);
      return DailySummary(
        date: entry.key,
        totalCalories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
      );
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (limit != null && limit > 0 && limit < summaries.length) {
      return summaries.sublist(0, limit);
    }
    return summaries;
  }
}
