import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';

class SessionManager {
  static const String _keyToken = 'AUTH_TOKEN';
  static const String _userKey = 'USER_DATA';
  
// Lưu và lấy token
static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }
  // Lưu và lấy User
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson()); // chuyển object -> String
    await prefs.setString(_userKey, userJson);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    final Map<String, dynamic> userMap = jsonDecode(userJson);
    return User.fromJson(userMap);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_userKey);
  }
}
