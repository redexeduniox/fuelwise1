import 'package:flutter/material.dart';
import 'package:fuelwise/models/food_entry.dart';
import 'package:fuelwise/services/food_service.dart';

class AddFoodPage extends StatefulWidget {
  final String? initialMealType;
  final String? initialName;
  final int? initialCalories;
  final double? initialProtein;
  final double? initialCarbs;
  final double? initialFats;

  const AddFoodPage({
    super.key,
    this.initialMealType,
    this.initialName,
    this.initialCalories,
    this.initialProtein,
    this.initialCarbs,
    this.initialFats,
  });

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();
  
  String _selectedMealType = 'Breakfast';
  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  final FoodService _foodService = FoodService();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Prefill values if provided
    _selectedMealType = widget.initialMealType ?? _selectedMealType;
    if (widget.initialName != null) _nameController.text = widget.initialName!;
    if (widget.initialCalories != null) {
      _caloriesController.text = widget.initialCalories!.toString();
    }
    if (widget.initialProtein != null) {
      _proteinController.text = widget.initialProtein!.toStringAsFixed(1);
    }
    if (widget.initialCarbs != null) {
      _carbsController.text = widget.initialCarbs!.toStringAsFixed(1);
    }
    if (widget.initialFats != null) {
      _fatsController.text = widget.initialFats!.toStringAsFixed(1);
    }
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      final entry = FoodEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '1',
        name: _nameController.text,
        calories: int.parse(_caloriesController.text),
        protein: double.parse(_proteinController.text),
        carbs: double.parse(_carbsController.text),
        fats: double.parse(_fatsController.text),
        mealType: _selectedMealType,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _foodService.addEntry(entry);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Food Entry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Meal Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMealType,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1A1A1A),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    items: _mealTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                    onChanged: (value) => setState(() => _selectedMealType = value!),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField('Food Name', _nameController, 'Enter food name'),
              const SizedBox(height: 20),
              _buildTextField('Calories', _caloriesController, 'Enter calories', isNumber: true),
              const SizedBox(height: 20),
              _buildTextField('Protein (g)', _proteinController, 'Enter protein', isDecimal: true),
              const SizedBox(height: 20),
              _buildTextField('Carbs (g)', _carbsController, 'Enter carbs', isDecimal: true),
              const SizedBox(height: 20),
              _buildTextField('Fats (g)', _fatsController, 'Enter fats', isDecimal: true),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Save Entry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool isNumber = false, bool isDecimal = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: isNumber || isDecimal ? TextInputType.number : TextInputType.text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'This field is required';
              if (isNumber && int.tryParse(value) == null) return 'Enter a valid number';
              if (isDecimal && double.tryParse(value) == null) return 'Enter a valid number';
              return null;
            },
          ),
        ),
      ],
    );
  }
}
