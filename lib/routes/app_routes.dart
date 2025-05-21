import 'package:flutter/material.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/signup_screen.dart';
import '../features/authentication/screens/verify_otp_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/details/screens/tutor_profile_screen.dart'; // New import
import '../features/details/screens/course_detail_screen.dart'; // New import

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifyOtp = '/verify-otp';
  static const String home = '/home';
  static const String tutorProfile = '/tutor-profile'; // New route
  static const String courseDetails = '/course-details'; // New route

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case verifyOtp:
        final args = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => VerifyOtpScreen(email: args));
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case tutorProfile:
        final args = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => TutorProfileScreen(accountId: args));
      case courseDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => CourseDetailsScreen(courseData: args));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}