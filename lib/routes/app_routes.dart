import 'package:flutter/material.dart';
import 'package:tutor/features/certification/register_tutor_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/signup_screen.dart';
import '../features/authentication/screens/verify_otp_screen.dart';
import '../features/home/screens/home_screen.dart'; // New import

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifyOtp = '/verify-otp';
  static const String home = '/home'; // New route
  static const String tutor = '/tutor';

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
      case tutor:
        return MaterialPageRoute(builder: (_) => const RegisterTutorScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
