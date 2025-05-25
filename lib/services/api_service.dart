import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/models/course_item.dart';
import 'package:tutor/common/models/statistic_data.dart';
import 'package:tutor/common/models/tutor.dart';
import 'package:tutor/common/models/tutor_certification.dart';
import 'package:tutor/common/models/tutor_profile.dart';
import 'package:tutor/common/utils/shared_prefs.dart';

class ApiService {
  static const String baseUrl =
      'https://exe202-booking-tutor-backend.onrender.com';

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 400) {
        throw Exception(
          'Login failed: Invalid input or account not active - ${response.body}',
        );
      } else if (response.statusCode == 401) {
        throw Exception('Login failed: Invalid credentials - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Login failed: Account not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception(
          'Login failed: Internal server error - ${response.body}',
        );
      } else {
        throw Exception(
          'Failed to login: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Login API Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
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
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 400) {
        throw Exception(
          'Registration failed: Invalid input - ${response.body}',
        );
      } else if (response.statusCode == 409) {
        throw Exception(
          'Registration failed: Email already exists - ${response.body}',
        );
      } else if (response.statusCode == 500) {
        throw Exception(
          'Registration failed: Internal server error - ${response.body}',
        );
      } else {
        throw Exception(
          'Failed to register: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Register API Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
    String email,
    String otp,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception(
        'OTP verification failed: Invalid or expired OTP - ${response.body}',
      );
    } else if (response.statusCode == 404) {
      throw Exception(
        'OTP verification failed: Account not found - ${response.body}',
      );
    } else if (response.statusCode == 500) {
      throw Exception(
        'OTP verification failed: Internal server error - ${response.body}',
      );
    } else {
      throw Exception(
        'Failed to verify OTP: ${response.statusCode} - ${response.body}',
      );
    }
  }

  //register tutor
  static Future<Map<String, dynamic>> registerTutor(
    String fullName,
    String email,
    String password,
    String phone,
  ) async {
    //create request body
    final requestBody = {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
    };

    //print to debug request body
    print('Register Tutor request body: ${jsonEncode(requestBody)}');

    //send request body with POST
    final response = await http.post(
      Uri.parse('$baseUrl/api/certifications/tutor/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    //print response
    print('Register Tutor API Response Status: ${response.statusCode}');
    print('Register Tutor API Response Body: ${response.body}');

    //response handling
    if (response.statusCode == 201) {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('JSON Parse Error: $e');
        throw Exception(
          'Invalid response format from server - ${response.body}',
        );
      }
    } else if (response.statusCode == 400) {
      throw Exception('Registration failed: Invalid input - ${response.body}');
    } else if (response.statusCode == 500) {
      throw Exception(
        'Registration failed: Internal server error - ${response.body}',
      );
    } else {
      throw Exception(
        'Failed to register tutor: ${response.statusCode} - ${response.body}',
      );
    }
  }

  //verify-otp tutor account
  static Future<Map<String, dynamic>> verifyOtpTutor(
    String email,
    String otp,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/certifications/tutor/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception(
        'OTP verification failed: Invalid or expired OTP - ${response.body}',
      );
    } else if (response.statusCode == 404) {
      throw Exception(
        'OTP verification failed: Account not found - ${response.body}',
      );
    } else if (response.statusCode == 500) {
      throw Exception(
        'OTP verification failed: Internal server error - ${response.body}',
      );
    } else {
      throw Exception(
        'Failed to verify OTP: ${response.statusCode} - ${response.body}',
      );
    }
  }

  //submit tutor certificate
  static Future<Certification> submitCertification({
    required String name,
    required String description,
    required List<File> imageFiles,
    required int experience,
  }) async {
    //get token to authorize through SharedPreferences
    final token = await SharedPrefs.getToken();
    List<String> imageUrls = [];

    try {
      if (imageFiles.isEmpty) {
        throw Exception('At least one image is required');
      }
      // Tải từng ảnh lên Supabase Storage
      for (var imageFile in imageFiles) {
        try {
          final fileName =
              '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
          final uploadResponse = await Supabase.instance.client.storage
              .from('images')
              .upload(fileName, imageFile);
          final imageUrl = Supabase.instance.client.storage
              .from('images')
              .getPublicUrl(fileName);

          // Kiểm tra URL hợp lệ
          final urlResponse = await http.head(Uri.parse(imageUrl));
          if (urlResponse.statusCode != 200) {
            throw Exception('Generated image URL is not accessible: $imageUrl');
          }

          imageUrls.add(imageUrl);
        } catch (e) {
          throw Exception('Failed to upload image: $e');
        }
      }
      // Gửi request API
      final response = await http.post(
        Uri.parse('$baseUrl/api/certifications/register'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'image': imageUrls,
          'experience': experience,
        }),
      );

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body);
        return Certification.fromJson(body['data']['certification']);
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(
          errorData['message'] ?? 'Failed to submit certification',
        );
      }
    } catch (e) {
      throw Exception('Error submitting certification: ${e.toString()}');
    }
  }

  //show profile
  static Future<TutorProfile> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    //get token
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/api/account/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TutorProfile.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - ${response.body}');
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error - ${response.body}');
    } else {
      throw Exception('Failed to load profile infor');
    }
  }

  //show cousrse by account
  static Future<List<Course>> getCourseByTutorId(String accountId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/courses/account/$accountId'),
    );

    //handle response
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final course = data['data']['courses'] as List;
      return course.map((e) => Course.fromJson(e)).toList();
    } else {
      throw Exception(body['message'] ?? "Failed to retrieve data");
    }
  }

  //create course
  static Future<Course> createCourse({
    required String name,
    required String description,
    String? image,
    required double price,
  }) async {
    final token = await SharedPrefs.getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/courses/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'image': image,
          'price': price,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['message'];
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Failed to create course');
      }
    } catch (e) {
      throw Exception('Error creating course: ${e.toString()}');
    }
  }

  //
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
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else {
        throw Exception(
          'Failed to fetch courses: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Courses API Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getAccountDetails(
    String accountId,
  ) async {
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
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else {
        throw Exception(
          'Failed to fetch account details: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Account Details API Error: $e');
      rethrow;
    }
  }

  //get all certiifcate with isCanCheck and isTeach is false
  static Future<List<Tutor>> getTutors() async {
    final token = await SharedPrefs.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/certifications/all-tutors'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    //handle response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> tutorsJson = data['data']['tutors'];
      final tutors = tutorsJson.map((json) => Tutor.fromJson(json)).toList();
      return tutors;
    } else {
      final errorData = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(errorData['message'] ?? "Failed to load data");
    }
  }

  //is can check
  static Future<void> checkCertification(String certificationId) async {
    final token = await SharedPrefs.getToken();

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/certifications/$certificationId/is-checked'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'isChecked': true}),
      );

      if (response.statusCode == 200) {
        print('Certification $certificationId approved successfully');
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Faild to check certification');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  //is can teach
  static Future<void> checkCertificationToTeach(String certificationId) async {
    final token = await SharedPrefs.getToken();

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/certifications/$certificationId/is-can-teach'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'isCanTeach': true}),
      );

      if (response.statusCode == 200) {
        print('Certification $certificationId approved to teach successfully');
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Faild to check certification');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  //get all course
  static Future<List<CourseItem>> getAllCourses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/courses'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['data'] == null || data['data']['courses'] == null) {
          throw Exception('Invalid API response: Missing data or courses');
        }
        final List<dynamic> coursesJson = data['data']['courses'];
        return coursesJson.map((json) => CourseItem.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to fetch courses: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  //revenue
  static Future<RevenueData> getRevenueReport(int year) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/dashboard/revenue/$year'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return RevenueData.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to load revenue report',
        );
      }
    } catch (e) {
      throw Exception('Error fetching revenue report: $e');
    }
  }

  //count account by status
  static Future<StatusData> getAccountStatusReport() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/dashboard/accounts/status'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StatusData.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to load revenue report',
        );
      }
    } catch (e) {
      throw Exception('Error fetching revenue report: $e');
    }
  }

  //count course by active status
  static Future<StatusData> getCourseStatusReport() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/dashboard/courses/status'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StatusData.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to load revenue report',
        );
      }
    } catch (e) {
      throw Exception('Error fetching revenue report: $e');
    }
  }

  //count top-account with most completed courses
  static Future<TopAccount> getTopAccountReport() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/dashboard/top-account'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TopAccount.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(
          errorData['message'] ?? 'Failed to load top account report',
        );
      }
    } catch (e) {
      throw Exception('Error fetching top account report: $e');
    }
  }
}
