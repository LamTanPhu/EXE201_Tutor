import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://exe202-booking-tutor-backend.onrender.com';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
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
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('Registration failed: Invalid input - ${response.body}');
    } else if (response.statusCode == 409) {
      throw Exception('Registration failed: Email already exists - ${response.body}');
    } else if (response.statusCode == 500) {
      throw Exception('Registration failed: Internal server error - ${response.body}');
    } else {
      throw Exception('Failed to register: ${response.statusCode} - ${response.body}');
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
}