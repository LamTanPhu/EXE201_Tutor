import 'package:http/http.dart' as http;
import 'dart:convert';

// TODO: Make baseUrl configurable (e.g., via environment variables or a config file)
class ApiService {
  static const String baseUrl = 'https://exe202-booking-tutor-backend.onrender.com';

  // Helper method to centralize headers (can be expanded for auth tokens later)
  static Map<String, String> _getHeaders() {
    return {'Content-Type': 'application/json'};
  }

  // Existing POST method: Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: _getHeaders(),
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

  // Existing POST method: Register
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

  // Existing POST method: Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
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
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('OTP verification failed: Invalid or expired OTP - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('OTP verification failed: Account not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('OTP verification failed: Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Verify OTP API Error: $e');
      rethrow;
    }
  }

  // Existing POST method: Register Certification
  static Future<Map<String, dynamic>> registerCertification(Map<String, dynamic> certificationData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/certifications/register'),
        headers: _getHeaders(),
        body: jsonEncode(certificationData),
      );
      print('Register Certification API Response Status: ${response.statusCode}');
      print('Register Certification API Response Body: ${response.body}');
      if (response.statusCode == 201) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid certification data - ${response.body}');
      } else if (response.statusCode == 409) {
        throw Exception('Certification already exists - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to register certification: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Register Certification API Error: $e');
      rethrow;
    }
  }

  // Existing POST method: Create Course
  static Future<Map<String, dynamic>> createCourse(Map<String, dynamic> courseData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/courses'),
        headers: _getHeaders(),
        body: jsonEncode(courseData),
      );
      print('Create Course API Response Status: ${response.statusCode}');
      print('Create Course API Response Body: ${response.body}');
      if (response.statusCode == 201) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid course data - ${response.body}');
      } else if (response.statusCode == 409) {
        throw Exception('Course already exists - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to create course: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Create Course API Error: $e');
      rethrow;
    }
  }

  // Existing POST method: Submit Feedback
  static Future<Map<String, dynamic>> submitFeedback(Map<String, dynamic> feedbackData) async {
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
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid feedback data - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to submit feedback: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Submit Feedback API Error: $e');
      rethrow;
    }
  }

  // Existing POST method: Create Order
  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
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
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid order data - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to create order: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Create Order API Error: $e');
      rethrow;
    }
  }

  // Existing POST method: Register Tutor Certification
  static Future<Map<String, dynamic>> registerTutorCertification(Map<String, dynamic> tutorCertificationData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/certifications/tutor/register'),
        headers: _getHeaders(),
        body: jsonEncode(tutorCertificationData),
      );
      print('Register Tutor Certification API Response Status: ${response.statusCode}');
      print('Register Tutor Certification API Response Body: ${response.body}');
      if (response.statusCode == 201) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid tutor certification data - ${response.body}');
      } else if (response.statusCode == 409) {
        throw Exception('Tutor certification already exists - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to register tutor certification: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Register Tutor Certification API Error: $e');
      rethrow;
    }
  }

  // Existing POST method: Verify Tutor Certification OTP
  static Future<Map<String, dynamic>> verifyTutorCertificationOtp(Map<String, dynamic> otpData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/certifications/tutor/verify-otp'),
        headers: _getHeaders(),
        body: jsonEncode(otpData),
      );
      print('Verify Tutor Certification OTP API Response Status: ${response.statusCode}');
      print('Verify Tutor Certification OTP API Response Body: ${response.body}');
      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid OTP - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Tutor not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Verify Tutor Certification OTP API Error: $e');
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

  // Existing GET method: Get Account Details
  static Future<Map<String, dynamic>> getAccountDetails(String accountId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/courses/account/$accountId'),
        headers: _getHeaders(),
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

  // Existing GET method: Get All Tutors' Certifications
  static Future<List<dynamic>> getAllTutorsCertifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/certifications/all-tutors'),
        headers: _getHeaders(),
      );

      print('All Tutors Certifications API Response Status: ${response.statusCode}');
      print('All Tutors Certifications API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as List<dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('No certifications found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to fetch certifications: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('All Tutors Certifications API Error: $e');
      rethrow;
    }
  }

  // Existing GET method: Get Accounts Status Dashboard
  static Future<Map<String, dynamic>> getAccountsStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/dashboard/accounts/status'),
        headers: _getHeaders(),
      );

      print('Accounts Status API Response Status: ${response.statusCode}');
      print('Accounts Status API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to fetch accounts status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Accounts Status API Error: $e');
      rethrow;
    }
  }

  // Existing GET method: Get Courses Status Dashboard
  static Future<Map<String, dynamic>> getCoursesStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/dashboard/courses/status'),
        headers: _getHeaders(),
      );

      print('Courses Status API Response Status: ${response.statusCode}');
      print('Courses Status API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to fetch courses status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Courses Status API Error: $e');
      rethrow;
    }
  }

  // Existing GET method: Get Top Account Dashboard
  static Future<Map<String, dynamic>> getTopAccount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/dashboard/top-account'),
        headers: _getHeaders(),
      );

      print('Top Account API Response Status: ${response.statusCode}');
      print('Top Account API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('No top account found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to fetch top account: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Top Account API Error: $e');
      rethrow;
    }
  }

  // Existing GET method: Get Feedback for a Course
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
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('No feedback found for course - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to fetch course feedback: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Course Feedback API Error: $e');
      rethrow;
    }
  }

  // Existing GET method: Get Revenue for a Year
  static Future<Map<String, dynamic>> getRevenueByYear(String year) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/dashboard/revenue/$year'),
        headers: _getHeaders(),
      );

      print('Revenue by Year API Response Status: ${response.statusCode}');
      print('Revenue by Year API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('No revenue data found for year - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to fetch revenue data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Revenue by Year API Error: $e');
      rethrow;
    }
  }

  // Existing GET method: Get All Orders
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
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('No orders found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Orders API Error: $e');
      rethrow;
    }
  }

  // Existing GET method: Get Account Profile
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
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Profile not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to fetch account profile: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Account Profile API Error: $e');
      rethrow;
    }
  }

  // Existing GET method: Get Tutor Order Details
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
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('No order details found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to fetch tutor order details: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Tutor Order Details API Error: $e');
      rethrow;
    }
  }

  // New PUT method: Update Account Profile
  static Future<Map<String, dynamic>> updateAccountProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/account/profile'),
        headers: _getHeaders(),
        body: jsonEncode(profileData),
      );

      print('Update Account Profile API Response Status: ${response.statusCode}');
      print('Update Account Profile API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid profile data - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Profile not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to update account profile: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Update Account Profile API Error: $e');
      rethrow;
    }
  }

  // New PATCH method: Update Certification Is Checked
  static Future<Map<String, dynamic>> updateCertificationIsChecked(String certificationId, bool isChecked) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/certifications/$certificationId/is-checked'),
        headers: _getHeaders(),
        body: jsonEncode({'isChecked': isChecked}),
      );

      print('Update Certification Is Checked API Response Status: ${response.statusCode}');
      print('Update Certification Is Checked API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid request data - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Certification not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to update certification isChecked: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Update Certification Is Checked API Error: $e');
      rethrow;
    }
  }

  // New PATCH method: Update Certification Is Can Teach
  static Future<Map<String, dynamic>> updateCertificationIsCanTeach(String certificationId, bool isCanTeach) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/certifications/$certificationId/is-can-teach'),
        headers: _getHeaders(),
        body: jsonEncode({'isCanTeach': isCanTeach}),
      );

      print('Update Certification Is Can Teach API Response Status: ${response.statusCode}');
      print('Update Certification Is Can Teach API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } catch (e) {
          print('JSON Parse Error: $e');
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid request data - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Certification not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to update certification isCanTeach: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Update Certification Is Can Teach API Error: $e');
      rethrow;
    }
  }

  // New PATCH method: Pay Order
  static Future<Map<String, dynamic>> payOrder(String orderId, Map<String, dynamic> paymentData) async {
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
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid payment data - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Order not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to pay order: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Pay Order API Error: $e');
      rethrow;
    }
  }

  // New PATCH method: Complete Course
  static Future<Map<String, dynamic>> completeCourse(String orderDetailId) async {
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
          throw Exception('Invalid response format from server - ${response.body}');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid request data - ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Order detail not found - ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error - ${response.body}');
      } else {
        throw Exception('Failed to complete course: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Complete Course API Error: $e');
      rethrow;
    }
  }
}