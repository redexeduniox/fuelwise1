import 'package:flutter/material.dart';
import 'package:fuelwise/models/user.dart';
import 'package:fuelwise/models/food_entry.dart';
import 'package:fuelwise/services/user_service.dart';
import 'package:fuelwise/services/food_service.dart';
import 'package:fuelwise/widgets/calorie_progress_card.dart';
import 'package:fuelwise/widgets/macros_card.dart';
import 'package:fuelwise/widgets/meal_section.dart';
import 'package:fuelwise/screens/add_food_page.dart';
import 'package:fuelwise/screens/food_search_page.dart';
import 'package:fuelwise/screens/settings_page.dart';
import 'package:fuelwise/screens/history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserService _userService = UserService();
  final FoodService _foodService = FoodService();
  
  User? _user;
  List<FoodEntry> _todayEntries = [];
  int _totalCalories = 0;
  Map<String, double> _macros = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _userService.getCurrentUser();
    final entries = await _foodService.getEntriesByDate(DateTime.now());
    final totalCals = await _foodService.getTotalCaloriesToday();
    final macros = await _foodService.getMacronutrientsToday();
    
    setState(() {
      _user = user;
      _todayEntries = entries;
      _totalCalories = totalCals;
      _macros = macros;
    });
  }

  Future<void> _deleteEntry(String id) async {
    await _foodService.deleteEntry(id);
    await _loadData();
  }

  List<FoodEntry> _getEntriesByMeal(String mealType) =>
    _todayEntries.where((e) => e.mealType == mealType).toList();

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, ${_user!.name}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Track your daily calories',
                        style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
                          await _loadData();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.history, color: Color(0xFFFFA726), size: 24),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
                          await _loadData();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.settings_outlined, color: Color(0xFF6C63FF), size: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    CalorieProgressCard(
                      totalCalories: _totalCalories,
                      goalCalories: _user!.dailyCalorieGoal,
                    ),
                    const SizedBox(height: 24),
                    MacrosCard(macros: _macros),
                    const SizedBox(height: 32),
                    MealSection(
                      title: 'Breakfast',
                      entries: _getEntriesByMeal('Breakfast'),
                      onDelete: _deleteEntry,
                    ),
                    const SizedBox(height: 24),
                    MealSection(
                      title: 'Lunch',
                      entries: _getEntriesByMeal('Lunch'),
                      onDelete: _deleteEntry,
                    ),
                    const SizedBox(height: 24),
                    MealSection(
                      title: 'Dinner',
                      entries: _getEntriesByMeal('Dinner'),
                      onDelete: _deleteEntry,
                    ),
                    const SizedBox(height: 24),
                    MealSection(
                      title: 'Snack',
                      entries: _getEntriesByMeal('Snack'),
                      onDelete: _deleteEntry,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodSearchPage()));
          await _loadData();
        },
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Food', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
