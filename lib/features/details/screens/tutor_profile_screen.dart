import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/tutor_hero_widget.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/tutor_profile_widget.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/tutor_courses_widget.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/tutor_certifications_widget.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/tutor_feedback_widget.dart';

class TutorProfileScreen extends StatefulWidget {
  final String? accountId;

  const TutorProfileScreen({super.key, this.accountId});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _teacherData;
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchTeacherDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTeacherDetails() async {
    try {
      if (widget.accountId != null) {
        final response = await ApiService.getAccountDetails(widget.accountId!);
        setState(() {
          _teacherData = response['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching teacher details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor Profile'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.white,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _teacherData == null
            ? const Center(child: Text('No data available'))
            : Column(
          children: [
            TutorHeroWidget(
              fullName: _teacherData?['account']['fullName'] ?? 'Unknown Tutor',
              role: _teacherData?['account']['role'] ?? 'Tutor',
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                indicatorWeight: 3.0,
                labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                tabs: const [
                  Tab(text: 'Profile'),
                  Tab(text: 'Courses'),
                  Tab(text: 'Certifications'),
                  Tab(text: 'Feedback'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TutorProfileWidget(
                    fullName: _teacherData?['account']['fullName'] ?? 'N/A',
                    role: _teacherData?['account']['role'] ?? 'N/A',
                    bio: _teacherData?['account']['bio'] ??
                        'Experienced tutor with a passion for teaching and helping students succeed.',
                    email: _teacherData?['account']['email'] ?? 'N/A',
                    phone: _teacherData?['account']['phone'] ?? 'N/A',
                    status: _teacherData?['account']['status'] ?? 'N/A',
                  ),
                  TutorCoursesWidget(
                    courses: _teacherData?['courses'] ?? [],
                  ),
                  TutorCertificationsWidget(
                    certifications: _teacherData?['certifications'] ?? [],
                  ),
                  const TutorFeedbackWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}