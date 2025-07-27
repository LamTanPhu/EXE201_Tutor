import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _keyToken = 'token';
  static const String _keyRole = 'role';
  static const String _keyFullName = 'fullName';
  static const String _keyAccountId = 'accountId';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  static Future<void> saveFullName(String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFullName, fullName);
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFullName);
  }

  static Future<void> saveAccountId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccountId, id);
  }

  static Future<String?> getAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccountId);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
