import 'package:flutter/material.dart';
import 'package:tutor/common/enums/role.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/features/admin/screens/account_management_screen.dart';
import 'package:tutor/features/account/tutor_profile_screen.dart';
import 'package:tutor/features/admin/screens/all_courses_screen.dart';
import 'package:tutor/features/admin/screens/reports_screen.dart';
import 'package:tutor/features/admin/screens/review_certification_screen.dart';
import 'package:tutor/features/home/screens/about_us_screen.dart';
import 'package:tutor/features/home/screens/home_screen.dart';
import 'package:tutor/features/tutor/screens/certification_screen.dart';
import 'package:tutor/features/tutor/screens/course_screen.dart';

class BottomNavLayoutWidget extends StatefulWidget {
  final Role role;
  const BottomNavLayoutWidget({super.key, required this.role});

  @override
  State<BottomNavLayoutWidget> createState() => _BottomNavLayoutWidgetState();
}

class _BottomNavLayoutWidgetState extends State<BottomNavLayoutWidget> {
  int _selectedIndex = 0;

  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switch (widget.role) {
      case Role.tutor:
        _pages = [
          //TutorDashboardScreen(),
          CertificationScreen(),
          CourseScreen(),
          TutorProfileScreen(),
        ];
        _items = const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Certifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ];
        break;

      case Role.student:
        _pages = [HomeScreen(), AboutUsScreen()];
        _items = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ];
        break;

      case Role.admin:
        _pages = [
          ReportsScreen(),
          GetAllCoursesScreen(),
          AccountManagementScreen(),
          ReviewCertificationScreen(),
          TutorProfileScreen(),
        ];
        _items = const [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Báo cáo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Các khoá học',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Gia sư',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Chứng chỉ',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        ];
        break;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightPrimary,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
      ),
    );
  }
}
