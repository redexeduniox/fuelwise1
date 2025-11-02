import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fuelwise/models/daily_summary.dart';
import 'package:fuelwise/services/food_service.dart';
import 'package:fuelwise/services/user_service.dart';
import 'package:fuelwise/models/user.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FoodService _foodService = FoodService();
  final UserService _userService = UserService();

  List<DailySummary> _summaries = [];
  User? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await _userService.getCurrentUser();
    final summaries = await _foodService.getDailySummaries();
    setState(() {
      _user = user;
      _summaries = summaries;
      _loading = false;
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(date.year, date.month, date.day);
    if (that == today) return 'Today';
    if (that == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('EEE, MMM d, yyyy').format(date);
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
        title: const Text('History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _summaries.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'No history yet. Add some entries to see daily summaries.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _summaries.length,
                  itemBuilder: (context, index) {
                    final s = _summaries[index];
                    return _DailySummaryTile(
                      summary: s,
                      goalCalories: _user?.dailyCalorieGoal ?? 2000,
                    );
                  },
                ),
    );
  }
}

class _DailySummaryTile extends StatelessWidget {
  final DailySummary summary;
  final int goalCalories;

  const _DailySummaryTile({required this.summary, required this.goalCalories});

  @override
  Widget build(BuildContext context) {
    final dateLabel = _labelFor(summary.date);
    final progress = goalCalories > 0
        ? (summary.totalCalories / goalCalories).clamp(0.0, 1.0)
        : 0.0;
    final isOver = summary.totalCalories > goalCalories;
    final overBy = isOver ? (summary.totalCalories - goalCalories) : 0;
    final badgeColor = isOver ? const Color(0xFFFF6B9D) : const Color(0xFF00D9A5);
    final badgeBg = badgeColor.withValues(alpha: 0.15);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isOver
                      ? '${summary.totalCalories} / $goalCalories • Over by $overBy'
                      : '${summary.totalCalories} / $goalCalories cal',
                  style: TextStyle(color: badgeColor, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation(isOver ? const Color(0xFFFF6B9D) : const Color(0xFF00D9A5)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip('Protein', '${summary.protein.toStringAsFixed(1)}g', const Color(0xFFFF6B9D)),
              const SizedBox(width: 8),
              _chip('Carbs', '${summary.carbs.toStringAsFixed(1)}g', const Color(0xFFFFA726)),
              const SizedBox(width: 8),
              _chip('Fats', '${summary.fats.toStringAsFixed(1)}g', const Color(0xFF00D9A5)),
            ],
          ),
        ],
      ),
    );
  }

  String _labelFor(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(date.year, date.month, date.day);
    if (that == today) return 'Today';
    if (that == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('EEE, MMM d').format(date);
  }

  Widget _chip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 12)),
          const SizedBox(width: 6),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}
