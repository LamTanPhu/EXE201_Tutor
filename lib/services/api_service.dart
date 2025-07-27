import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/models/account_detail.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/models/course_item.dart';
import 'package:tutor/common/models/statistic_data.dart';
import 'package:tutor/common/models/tutor.dart';
import 'package:tutor/common/utils/shared_prefs.dart';

// TODO: Make baseUrl configurable (e.g., via environment variables or a config file)

class ApiService {
  static const String baseUrl =
      'https://exe202-booking-tutor-backend.onrender.com';

  // Helper method to centralize headers (can be expanded for auth tokens later)
  static Map<String, String> _getHeaders() {
    return {'Content-Type': 'application/json'};
  }

  // Helper method to get headers with authorization
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await SharedPrefs.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // === AUTHENTICATION METHODS ===

  // POST method: Login
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: _getHeaders(),
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

  // POST method: Register
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
        headers: _getHeaders(),
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

  // POST method: Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(
    String email,
    String otp,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/verify-otp'),
        headers: _getHeaders(),
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      print('Verify OTP API Response Status: ${response.statusCode}');
      print('Verify OTP API Response Body: ${response.body}');

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
    } catch (e) {
      print('Verify OTP API Error: $e');
      rethrow;
    }
  }

  // === CERTIFICATION METHODS ===

  // POST method: Register Certification
  static Future<Map<String, dynamic>> registerCertification(
    Map<String, dynamic> certificationData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/certifications/register'),
        headers: _getHeaders(),
        body: jsonEncode(certificationData),
      );

      print(
        'Register Certification API Response Status: ${response.statusCode}',
      );
      print('Register Certification API Response Body: ${response.body}');

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
        throw Exception('Invalid certification data - ${response.body}');
      } else if (response.statusCode == 409) {
        throw Exception('Certification already exists - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to register certification: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Register Certification API Error: $e');
      rethrow;
    }
  }

  // POST method: Register Tutor Certification
  static Future<Map<String, dynamic>> registerTutorCertification(
    Map<String, dynamic> tutorCertificationData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/certifications/tutor/register'),
        headers: _getHeaders(),
        body: jsonEncode(tutorCertificationData),
      );

      print(
        'Register Tutor Certification API Response Status: ${response.statusCode}',
      );
      print('Register Tutor Certification API Response Body: ${response.body}');

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
        throw Exception('Invalid tutor certification data - ${response.body}');
      } else if (response.statusCode == 409) {
        throw Exception(
          'Tutor certification already exists - ${response.body}',
        );
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to register tutor certification: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Register Tutor Certification API Error: $e');
      rethrow;
    }
  }

  // POST method: Verify Tutor Certification OTP
  static Future<Map<String, dynamic>> verifyTutorCertificationOtp(
    Map<String, dynamic> otpData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/certifications/tutor/verify-otp'),
        headers: _getHeaders(),
        body: jsonEncode(otpData),
      );

      print(
        'Verify Tutor Certification OTP API Response Status: ${response.statusCode}',
      );
      print(
        'Verify Tutor Certification OTP API Response Body: ${response.body}',
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
        throw Exception('Invalid OTP - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Tutor not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to verify OTP: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Verify Tutor Certification OTP API Error: $e');
      rethrow;
    }
  }

  // GET method: Get All Tutors (with authentication)
  static Future<List<Tutor>> getTutors() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/certifications/all-tutors'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print('Get Tutors API Response Status: ${response.statusCode}');
        final List<dynamic> tutorsJson = data['data']['tutors'];
        return tutorsJson.map((json) => Tutor.fromJson(json)).toList();
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? "Failed to load tutors");
      }
    } catch (e) {
      print('Get Tutors API Error: $e');
      rethrow;
    }
  }

  // PATCH method: Check Certification (with authentication)
  static Future<void> checkCertification(String certificationId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.patch(
        Uri.parse('$baseUrl/api/certifications/$certificationId/is-checked'),
        headers: headers,
        body: jsonEncode({'isChecked': true}),
      );

      if (response.statusCode == 200) {
        print('Certification $certificationId approved successfully');
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(
          errorData['message'] ?? 'Failed to check certification',
        );
      }
    } catch (e) {
      print('Check Certification API Error: $e');
      rethrow;
    }
  }

  // PATCH method: Check Certification to Teach (with authentication)
  static Future<void> checkCertificationToTeach(String certificationId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.patch(
        Uri.parse('$baseUrl/api/certifications/$certificationId/is-can-teach'),
        headers: headers,
        body: jsonEncode({'isCanTeach': true}),
      );

      if (response.statusCode == 200) {
        print('Certification $certificationId approved to teach successfully');
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(
          errorData['message'] ??
              'Failed to approve certification for teaching',
        );
      }
    } catch (e) {
      print('Check Certification to Teach API Error: $e');
      rethrow;
    }
  }

  // === COURSE METHODS ===

  // // POST method: Create Course
  // static Future<Map<String, dynamic>> createCourse(Map<String, dynamic> courseData) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/api/courses'),
  //       headers: _getHeaders(),
  //       body: jsonEncode(courseData),
  //     );
  //
  //     print('Create Course API Response Status: ${response.statusCode}');
  //     print('Create Course API Response Body: ${response.body}');
  //
  //     if (response.statusCode == 201) {
  //       try {
  //         return jsonDecode(response.body) as Map<String, dynamic>;
  //       } catch (e) {
  //         print('JSON Parse Error: $e');
  //         throw Exception('Invalid response format from server - ${response.body}');
  //       }
  //     } else if (response.statusCode == 400) {
  //       throw Exception('Invalid course data - ${response.body}');
  //     } else if (response.statusCode == 409) {
  //       throw Exception('Course already exists - ${response.body}');
  //     } else if (response.statusCode == 500) {
  //       throw Exception('Internal server error - ${response.body}');
  //     } else {
  //       throw Exception('Failed to create course: ${response.statusCode} - ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Create Course API Error: $e');
  //     rethrow;
  //   }
  // }

  // GET method: Get All Courses
  static Future<List<CourseItem>> getAllCourses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/courses'),
        headers: _getHeaders(),
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
      print('Get All Courses API Error: $e');
      rethrow;
    }
  }

  // GET method: Get Course Feedback
  static Future<List<dynamic>> getCourseFeedback(String courseId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/feedback/course/$courseId'),
        headers: _getHeaders(),
      );

      print('Course Feedback API Response Status: ${response.statusCode}');
      print('Course Feedback API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as List<dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('No feedback found for course - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch course feedback: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Course Feedback API Error: $e');
      rethrow;
    }
  }

  // PATCH method: Complete Course
  static Future<Map<String, dynamic>> completeCourse(
    String orderDetailId,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/tutor/complete-course/$orderDetailId'),
        headers: _getHeaders(),
        body: jsonEncode({}),
      );

      print('Complete Course API Response Status: ${response.statusCode}');
      print('Complete Course API Response Body: ${response.body}');

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
        throw Exception('Invalid request data - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Order detail not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to complete course: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Complete Course API Error: $e');
      rethrow;
    }
  }

  // === FEEDBACK METHODS ===

  // POST method: Submit Feedback
  static Future<Map<String, dynamic>> submitFeedback(
    Map<String, dynamic> feedbackData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/feedback'),
        headers: _getHeaders(),
        body: jsonEncode(feedbackData),
      );

      print('Submit Feedback API Response Status: ${response.statusCode}');
      print('Submit Feedback API Response Body: ${response.body}');

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
        throw Exception('Invalid feedback data - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to submit feedback: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Submit Feedback API Error: $e');
      rethrow;
    }
  }

  // === ORDER METHODS ===

  // POST method: Create Order
  static Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> orderData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/orders'),
        headers: _getHeaders(),
        body: jsonEncode(orderData),
      );

      print('Create Order API Response Status: ${response.statusCode}');
      print('Create Order API Response Body: ${response.body}');

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
        throw Exception('Invalid order data - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to create order: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Create Order API Error: $e');
      rethrow;
    }
  }

  // GET method: Get All Orders
  static Future<List<dynamic>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/orders'),
        headers: _getHeaders(),
      );

      print('Orders API Response Status: ${response.statusCode}');
      print('Orders API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as List<dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('No orders found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch orders: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Orders API Error: $e');
      rethrow;
    }
  }

  // PATCH method: Pay Order
  static Future<Map<String, dynamic>> payOrder(
    String orderId,
    Map<String, dynamic> paymentData,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/orders/$orderId/pay'),
        headers: _getHeaders(),
        body: jsonEncode(paymentData),
      );

      print('Pay Order API Response Status: ${response.statusCode}');
      print('Pay Order API Response Body: ${response.body}');

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
        throw Exception('Invalid payment data - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Order not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to pay order: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Pay Order API Error: $e');
      rethrow;
    }
  }

  // === ACCOUNT METHODS ===

  // GET method: Get Account Details
  static Future<Map<String, dynamic>> getAccountDetails(
    String accountId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/courses/account/$accountId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
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
      rethrow;
    }
  }

  //GET Method: Get Chapter's content
  static Future<List<dynamic>> getChapterContent(String chapterId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/contents/chapter/$chapterId'),
        headers: _getHeaders(),
      );
      print('Chapter Content API Response Status: ${response.statusCode}');
      print('Chapter Content API Response Body: ${response.body}');
      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as List<dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('No content found for chapter - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch chapter content: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Chapter Content API Error: $e');
      rethrow;
    }
  }

  // GET method: Get Account Profile
  static Future<Map<String, dynamic>> getAccountProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/account/profile'),
        headers: _getHeaders(),
      );

      print('Account Profile API Response Status: ${response.statusCode}');
      print('Account Profile API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('Profile not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch account profile: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Account Profile API Error: $e');
      rethrow;
    }
  }

  // PUT method: Update Account Profile
  static Future<Map<String, dynamic>> updateAccountProfile(
    String fullName,
    String email,
    String phone,
    String avatar,
  ) async {
    final profileData = {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
    };
    try {
      final token = await SharedPrefs.getToken();

      final response = await http.put(
        Uri.parse('$baseUrl/api/account/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profileData),
      );

      print(
        'Update Account Profile API Response Status: ${response.statusCode}',
      );
      print('Update Account Profile API Response Body: ${response.body}');

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
        throw Exception('Invalid profile data - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Profile not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to update account profile: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Update Account Profile API Error: $e');
      rethrow;
    }
  }

  // === TUTOR METHODS ===

  // GET method: Get Tutor Order Details
  static Future<List<dynamic>> getTutorOrderDetails() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tutor/order-details'),
        headers: _getHeaders(),
      );

      print('Tutor Order Details API Response Status: ${response.statusCode}');
      print('Tutor Order Details API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as List<dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('No order details found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch tutor order details: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Tutor Order Details API Error: $e');
      rethrow;
    }
  }

  // === DASHBOARD/STATISTICS METHODS ===

  // GET method: Get Revenue Report
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
      print('Revenue Report API Error: $e');
      rethrow;
    }
  }

  // GET method: Get Account Status Report
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
          errorData['message'] ?? 'Failed to load account status report',
        );
      }
    } catch (e) {
      print('Account Status Report API Error: $e');
      rethrow;
    }
  }

  // GET method: Get Course Status Report
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
          errorData['message'] ?? 'Failed to load course status report',
        );
      }
    } catch (e) {
      print('Course Status Report API Error: $e');
      rethrow;
    }
  }

  // GET method: Get Top Account Report
  static Future<TopAccount> getTopAccountReport() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/dashboard/top-account'),
        headers: _getHeaders(),
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
      print('Top Account Report API Error: $e');
      rethrow;
    }
  }

  // Existing GET method: Get Courses
  static Future<Map<String, dynamic>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/courses'),
        headers: _getHeaders(),
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

  //show profile
  static Future<Account> getProfile() async {
    //get token
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/account/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Account.fromJson(json);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(
        errorData['message'] ?? 'Login failed: ${response.statusCode}',
      );
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
        Uri.parse('$baseUrl/api/courses'),
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
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final data = jsonData['data']['course'];

        return Course.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['message'] ?? 'Failed to create course');
      }
    } catch (e) {
      print('Create Course API Error: $e');

      throw Exception('Error creating course: ${e.toString()}');
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

  static Future<List<dynamic>> getCourseChapters(String courseId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/chapters/course/$courseId'),
        headers: _getHeaders(),
      );

      print('Course Chapters API Response Status: ${response.statusCode}');
      print('Course Chapters API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as List<dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('No chapters found for course - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch course chapters: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Course Chapters API Error: $e');
      rethrow;
    }
  }

  //POST METHOD: CREATE CHAPTER
  static Future<Map<String, dynamic>> createChapter(
    String title,
    String courseId,
  ) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/chapters'),
        headers: headers,
        body: jsonEncode({'title': title, 'courseId': courseId}),
      );

      print('Create Chapter API Response Status: ${response.statusCode}');
      print('Create Chapter API Response Body: ${response.body}');

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
        throw Exception('Invalid chapter data - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to create chapter: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Create Chapter API Error: $e');
      rethrow;
    }
  }

  //GET method: Get content by chapter ID
  static Future<List<dynamic>> getContentByChapterId(String chapterId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/contents/chapter/$chapterId'),
        headers: headers,
      );

      print(
        'Get Content by Chapter ID API Response Status: ${response.statusCode}',
      );
      print('Get Content by Chapter ID API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as List<dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('No content found for chapter - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch content by chapter ID: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Get Content by Chapter ID API Error: $e');
      rethrow;
    }
  }

  //POST Method: Create Content
  static Future<Map<String, dynamic>> createContent(
    String chapterId,
    String description,
    String accountId,
  ) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/contents'),
        headers: headers,
        body: jsonEncode({
          'chapterId': chapterId,
          'contentDescription': description,
          'createdBy': accountId,
        }),
      );

      print('Create Content API Response Status: ${response.statusCode}');
      print('Create Content API Response Body: ${response.body}');

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
        throw Exception('Invalid content data - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to create content: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Create Content API Error: $e');
      rethrow;
    }
  }

  // GET method: Get All Forum Posts
  static Future<List<dynamic>> getForumPosts() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/forum'),
        headers: headers,
      );

      print('Get Forum Posts API Response Status: ${response.statusCode}');
      print('Get Forum Posts API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as List<dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('No forum posts found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch forum posts: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Get Forum Posts API Error: $e');
      rethrow;
    }
  }

  // POST method: Create Forum Post
  static Future<Map<String, dynamic>> createForumPost(
    String title,
    String content,
  ) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/forum'),
        headers: headers,
        body: jsonEncode({'title': title, 'content': content}),
      );

      print('Create Forum Post API Response Status: ${response.statusCode}');
      print('Create Forum Post API Response Body: ${response.body}');

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
        throw Exception('Invalid forum post data - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to create forum post: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Create Forum Post API Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getForumPostById(String postId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/forum/$postId'),
        headers: headers,
      );

      print('Get Forum Post by ID API Response Status: ${response.statusCode}');
      print('Get Forum Post by ID API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('Forum post not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch forum post: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Get Forum Post by ID API Error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> likeForumPost(String postId) async {
    try {
      if (postId.length != 24 ||
          !RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(postId)) {
        throw Exception('Invalid postId format: $postId');
      }
      final headers = await _getAuthHeaders();
      final url = '$baseUrl/api/forum/$postId/like';

      print('Sending PUT like request to: $url');
      print('Headers: $headers');

      // Changed from PATCH to PUT
      final response = await http.put(Uri.parse(url), headers: headers);

      print('Like Forum Post API Response Status: ${response.statusCode}');
      print('Like Forum Post API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData =
              jsonDecode(response.body) as Map<String, dynamic>;
          return responseData;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('Forum post not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - please login again');
      } else if (response.statusCode == 400) {
        throw Exception('Invalid request - ${response.body}');
      } else {
        throw Exception(
          'Failed to like forum post: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Like Forum Post API Error: $e');
      rethrow;
    }
  }

  // POST method: Add Forum Feedback
  static Future<Map<String, dynamic>> addForumFeedback(
    String postId,
    String reply,
  ) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/forum/$postId/feedback'),
        headers: headers,
        body: jsonEncode({'reply': reply}),
      );

      print('Add Forum Feedback API Response Status: ${response.statusCode}');
      print('Add Forum Feedback API Response Body: ${response.body}');

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
        throw Exception('Invalid feedback data - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Forum post not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to add forum feedback: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Add Forum Feedback API Error: $e');
      rethrow;
    }
  }

  // GET method: Get Account Profile
  static Future<Account> getGuestAccountProfile() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/account/profile'),
        headers: headers,
      );

      print('Get Account Profile API Response Status: ${response.statusCode}');
      print('Get Account Profile API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return Account.fromJson(data);
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('Profile not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch account profile: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Get Account Profile API Error: $e');
      rethrow;
    }
  }

  // PUT method: Update Account Profile
  static Future<Account> updateGuestAccountProfile(
    String fullName,
    String email,
    String phone,
    String avatar,
  ) async {
    final profileData = {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
    };
    try {
      final headers = await _getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/account/profile'),
        headers: headers,
        body: jsonEncode(profileData),
      );

      print(
        'Update Account Profile API Response Status: ${response.statusCode}',
      );
      print('Update Account Profile API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return Account.fromJson(data);
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception(
            'Invalid response format from server - ${response.body}',
          );
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid profile data - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Profile not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to update account profile: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Update Account Profile API Error: $e');
      rethrow;
    }
  }

  // POST method: Create Order with VNPay Payment URL
  static Future<Map<String, dynamic>> createOrderWithPaymentUrl(
    String courseId,
  ) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/orders'),
        headers: headers,
        body: jsonEncode({'courseId': courseId}),
      );

      print(
        'Create Order with Payment URL API Response Status: ${response.statusCode}',
      );
      print(
        'Create Order with Payment URL API Response Body: ${response.body}',
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
        throw Exception('Invalid request data - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Course not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to create order with payment URL: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Create Order with Payment URL API Error: $e');
      rethrow;
    }
  }

  //GET method: Get course by accountId
  static Future<AccountDetail> getCourseByAccount(String accountId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/courses/account/$accountId'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'];
        return AccountDetail.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception({response.body});
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch account profile: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  //UPDATE method: Update course
  static Future<Course> updateCourse(
    String courseId,
    String? name,
    String? description,
    String? image,
    double? price,
  ) async {
    final courseData = {
      'name': name,
      'description': description,
      'image': image,
      'price': price,
    };
    try {
      final headers = await _getAuthHeaders();

      final response = await http.put(
        Uri.parse('$baseUrl/api/courses/$courseId'),
        headers: headers,
        body: jsonEncode(courseData),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data']['course'];
        return Course.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception({response.body});
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to update course: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  //GET: Get certification by tutor
  static Future<List<Certification>> getTutorCertifications() async {
    try {
      //get auth headers
      final header = await _getAuthHeaders();
      //call api
      final response = await http.get(
        Uri.parse('$baseUrl/api/tutor/certifications'),
        headers: header,
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((e) => Certification.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        throw Exception({response.body});
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception(
          'Failed to fetch account profile: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
