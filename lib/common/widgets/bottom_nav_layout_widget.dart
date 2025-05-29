import 'package:flutter/material.dart';
import 'package:tutor/common/enums/role.dart';
import 'package:tutor/features/account/tutor_profile_screen.dart';
import 'package:tutor/features/admin/screens/admin_dashboard_screen.dart';
import 'package:tutor/features/admin/screens/all_courses_screen.dart';
import 'package:tutor/features/admin/screens/reports_screen.dart';
import 'package:tutor/features/certification/submit_certificate_screen.dart';
import 'package:tutor/features/home/screens/about_us_screen.dart';
import 'package:tutor/features/home/screens/home_screen.dart';
import 'package:tutor/features/tutor/screens/course_creation_screen.dart';
import 'package:tutor/features/tutor/screens/tutor_course_screen.dart';
import 'package:tutor/features/tutor/screens/tutor_working_screen.dart';

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
          TutorWorkingScreen(),
          CreateCourseScreen(),
          SubmitCertificationScreen(),
          TutorProfileScreen(),
        ];
        _items = const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.upload_file), label: 'Cert'),
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
          AdminDashboardScreen(),
          GetAllCoursesScreen(),
          ReportsScreen(),
        ];
        _items = const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Courses',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Reports'),
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
