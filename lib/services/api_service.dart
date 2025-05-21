import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://exe202-booking-tutor-backend.onrender.com';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Login API Response Status: ${response.statusCode}');
      print('Login API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Login failed: Invalid input or account not active - ${response.body}');
      } else if (response.statusCode == 401) {
        throw Exception('Login failed: Invalid credentials - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Login failed: Account not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Login failed: Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Login API Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password, String phone) async {
    try {
      final requestBody = {
        'fullName': name,
        'email': email,
        'password': password,
        'phone': phone,
      };
      final encodedBody = jsonEncode(requestBody);
      print('Register Request Body: $encodedBody');

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: encodedBody,
      );

      print('Register API Response Status: ${response.statusCode}');
      print('Register API Response Body: ${response.body}');

      if (response.statusCode == 201) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Registration failed: Invalid input - ${response.body}');
      } else if (response.statusCode == 409) {
        throw Exception('Registration failed: Email already exists - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Registration failed: Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to register: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Register API Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('OTP verification failed: Invalid or expired OTP - ${response.body}');
    } else if (response.statusCode == 404) {
      throw Exception('OTP verification failed: Account not found - ${response.body}');
    } else if (response.statusCode == 500) {
      throw Exception('OTP verification failed: Internal server error - ${response.body}');
    } else {
      throw Exception('Failed to verify OTP: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/courses'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Courses API Response Status: ${response.statusCode}');
      print('Courses API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else {
        throw Exception('Failed to fetch courses: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Courses API Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getAccountDetails(String accountId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/courses/account/$accountId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Account Details API Response Status: ${response.statusCode}');
      print('Account Details API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else {
        throw Exception('Failed to fetch account details: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Account Details API Error: $e');
      rethrow;
    }
  }
}