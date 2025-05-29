
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  //save token
  static Future<void> saveToken(String token) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token',token);
  }


  ///get token
  static Future<String?> getToken() async{
final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null ) {
      return token;
    }
    return null;
  }
}