import 'package:flutter/material.dart';
import 'package:tutor/common/widgets/bottom_nav_bar.dart';
import 'package:tutor/features/account/tutor_profile_screen.dart';
import 'package:tutor/features/tutor/screens/tutor_working_screen.dart';

class TutorMain extends StatefulWidget {
  const TutorMain({super.key});

  @override
  State<TutorMain> createState() => _TutorMainState();
}

class _TutorMainState extends State<TutorMain> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    TutorWorkingScreen(),
    TutorProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
