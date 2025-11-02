import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fuelwise/models/user.dart';

class UserService {
  static const String _userKey = 'current_user';

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) {
      final defaultUser = User(
        id: '1',
        name: 'Guest User',
        dailyCalorieGoal: 2000,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await saveUser(defaultUser);
      return defaultUser;
    }
    return User.fromJson(json.decode(userJson));
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  Future<void> updateDailyGoal(int newGoal) async {
    final user = await getCurrentUser();
    if (user != null) {
      final updatedUser = user.copyWith(
        dailyCalorieGoal: newGoal,
        updatedAt: DateTime.now(),
      );
      await saveUser(updatedUser);
    }
  }

  Future<void> updateName(String newName) async {
    final user = await getCurrentUser();
    if (user != null) {
      final updatedUser = user.copyWith(
        name: newName,
        updatedAt: DateTime.now(),
      );
      await saveUser(updatedUser);
    }
  }
}
