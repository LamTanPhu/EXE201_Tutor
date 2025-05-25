import 'package:flutter/material.dart';
import 'package:tutor/features/account/tutor_profile_screen.dart';
import 'package:tutor/features/admin/screens/admin_dashboard_screen.dart';
import 'package:tutor/features/admin/screens/all_courses_screen.dart';
import 'package:tutor/features/admin/screens/reports_screen.dart';
import 'package:tutor/features/certification/register_tutor_screen.dart';
import 'package:tutor/features/admin/screens/review_certification_screen.dart';
import 'package:tutor/features/certification/submit_certificate_screen.dart';
import 'package:tutor/features/details/screens/tutor_details_screen.dart';
import 'package:tutor/features/tutor/screens/course_creation_screen.dart';
import 'package:tutor/features/tutor/screens/tutor_course_screen.dart';
import 'package:tutor/features/tutor/widgets/tutor_main.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/signup_screen.dart';
import '../features/authentication/screens/verify_otp_screen.dart';
import '../features/home/screens/home_screen.dart';
// import '../features/details/screens/tutor_details_screen.dart'; // New import
import '../features/details/screens/course_detail_screen.dart'; // New import

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifyOtp = '/verify-otp';
  static const String home = '/home'; // New route
  static const String tutor = '/signup/tutor';
  static const String tutorInfo = '/tutor';
  static const String review = '/admin/certifications/review';
  static const String tutorProfile = '/tutor-profile'; // New route
  static const String courseDetails = '/course-details'; // New route
  static const String tutorMain = '/tutor/home';
  static const String studentMain = '/student/home';
  static const String ceritification_upload = 'tutor/cert/submit';
  static const String tutor_course = '/tutor/courses';
  static const String course_create = '/courses/create';
  //admin
  static const String adminDashboard = '/admin/dashboard';
  static const String certifApprove = '/admin/certifi';
  static const String allCourses = '/admin/courses';
  static const String reports = '/admin/reports';


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
      case review:
        return MaterialPageRoute(
          builder: (_) => const ReviewCertificationScreen(),
        );
      case tutorProfile:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => TutorDetailsScreen(accountId: args),
        );
      case tutorMain:
        return MaterialPageRoute(builder: (_) => const TutorMain());
      case tutorInfo:
        return MaterialPageRoute(builder: (_) => const TutorProfileScreen());
      case ceritification_upload:
        return MaterialPageRoute(
          builder: (_) => const SubmitCertificationScreen(),
        );
      // case tutor_course:
      //   final args = settings.arguments as String;
      //   return MaterialPageRoute(
      //     builder: (_) => TutorCourseScreen(accountId: args),
      //   );
      case courseDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CourseDetailsScreen(courseData: args),
        );

      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      case certifApprove:
        return MaterialPageRoute(
          builder: (_) => const ReviewCertificationScreen(),
        );
      case allCourses:
        return MaterialPageRoute(builder: (_) => const GetAllCoursesScreen());
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case course_create:
      return MaterialPageRoute(builder: (_) => const CreateCourseScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
