import 'package:flutter/material.dart';
import 'package:tutor/common/enums/role.dart';
import 'package:tutor/common/widgets/bottom_nav_layout_widget.dart';
import 'package:tutor/features/account/tutor_profile_screen.dart';
import 'package:tutor/features/admin/screens/account_detail_screen.dart';
import 'package:tutor/features/admin/screens/all_courses_screen.dart';
import 'package:tutor/features/admin/screens/reports_screen.dart';
import 'package:tutor/features/tutor/screens/register_tutor_screen.dart';
import 'package:tutor/features/admin/screens/review_certification_screen.dart';
import 'package:tutor/features/certification/submit_certificate_screen.dart';
import 'package:tutor/features/details/screens/tutor_details_screen.dart';
import 'package:tutor/features/details/screens/chapter_details_screen.dart';
import 'package:tutor/features/home/screens/about_us_screen.dart';
import 'package:tutor/features/tutor/screens/course_creation_screen.dart';
import 'package:tutor/features/authentication/screens/login_screen.dart';
import 'package:tutor/features/authentication/screens/signup_screen.dart';
import 'package:tutor/features/authentication/screens/verify_otp_screen.dart';
import 'package:tutor/features/home/screens/home_screen.dart';
import 'package:tutor/features/details/screens/course_detail_screen.dart';
import 'package:tutor/features/forum/screens/forum_screen.dart';

import '../features/details/screens/forum_details_screen.dart'; // New import

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifyOtp = '/verify-otp';
  static const String home = '/home';
  static const String aboutUs = '/about-us';
  static const String tutor = '/signup/tutor';
  static const String tutorInfo = '/tutor';
  static const String review = '/admin/certifications/review';
  static const String tutorProfile = '/tutor-profile';
  static const String courseDetails = '/course-details';
  static const String tutorMain = '/tutor/home';
  static const String studentMain = '/student/home';
  static const String ceritificationUpload = '/tutor/cert/submit';
  static const String tutorCourse = '/tutor/courses';
  static const String courseCreate = '/courses/create';
  static const String adminDashboard = '/admin/dashboard';
  static const String certifApprove = '/admin/certifi';
  static const String allCourses = '/admin/courses';
  static const String reports = '/admin/reports';
  static const String accountDetail = '/admin/accounts/';
  static const String chapterDetails = '/chapter-details';
  static const String forum = '/forum'; // New route
  static const String forumDetails = '/forum-details';


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
      case aboutUs:
        return MaterialPageRoute(builder: (_) => const AboutUsScreen());
      case tutor:
        return MaterialPageRoute(builder: (_) => const RegisterTutorScreen());
      case review:
        return MaterialPageRoute(builder: (_) => ReviewCertificationScreen());
      case tutorProfile:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => TutorDetailsScreen(accountId: args),
        );
      case tutorMain:
        return MaterialPageRoute(
          builder: (_) => const BottomNavLayoutWidget(role: Role.tutor),
        );
      case tutorInfo:
        return MaterialPageRoute(builder: (_) => const TutorProfileScreen());
      case ceritificationUpload:
        return MaterialPageRoute(
          builder: (_) => const SubmitCertificationScreen(),
        );
      case courseDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CourseDetailsScreen(
            courseId: args?['courseId'] ?? 'unknown',
            courseData: args?['courseData'],
          ),
        );
      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const BottomNavLayoutWidget(role: Role.admin),
        );
      case certifApprove:
        return MaterialPageRoute(
          builder: (_) => const ReviewCertificationScreen(),
        );
      case allCourses:
        return MaterialPageRoute(builder: (_) => const GetAllCoursesScreen());
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case courseCreate:
        return MaterialPageRoute(builder: (_) => const CreateCourseScreen());
      case accountDetail:
        return MaterialPageRoute(builder: (_) => const AccountDetailScreen());
      case chapterDetails:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => ChapterDetailsScreen(chapterId: args ?? 'unknown'),
        );
      case forum: // New case for ForumScreen
        return MaterialPageRoute(builder: (_) => const ForumScreen());
      case forumDetails:
        final args = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => ForumDetailsScreen(postId: args ?? 'unknown'),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}