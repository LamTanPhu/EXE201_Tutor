
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _tokenKey = 'authToken';

  //save token
  static Future<void> saveToken(String token) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }


  ///get token
  static Future<String?> getToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  //remove token
  static Future<void> removeToken() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}