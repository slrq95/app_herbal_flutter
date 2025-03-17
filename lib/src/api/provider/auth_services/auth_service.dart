import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static const String _keyUsername = 'username';
  static const String _keyPassword = 'password';

  // Save credentials
  static Future<void> saveUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPassword, password);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUsername);
  }

  // Get stored user
  static Future<Map<String, String>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(_keyUsername);
    String? password = prefs.getString(_keyPassword);
    if (username != null && password != null) {
      return {'username': username, 'password': password};
    }
    return null;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
