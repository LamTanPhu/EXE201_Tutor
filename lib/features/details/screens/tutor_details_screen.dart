import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/tutor_hero_widget.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/tutor_profile_widget.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/tutor_courses_widget.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/tutor_certifications_widget.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/tutor_feedback_widget.dart';

class TutorDetailsScreen extends StatefulWidget {
  final String? accountId;

  const TutorDetailsScreen({super.key, this.accountId});

  @override
  State<TutorDetailsScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _teacherData;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchTeacherDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  Future<void> _fetchTeacherDetails() async {
    if (_teacherData != null || widget.accountId == null) return;
    _isLoading.value = true;
    try {
      final response = await ApiService.getAccountDetails(widget.accountId!);
      if (mounted) {
        _teacherData = response['data'];
        _isLoading.value = false;
      }
    } catch (e) {
      if (mounted) {
        _errorMessage = 'Error fetching teacher details: $e';
        _isLoading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ gia sư'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_errorMessage != null) {
              return Center(child: Text(_errorMessage!));
            }
            if (_teacherData == null) {
              return const Center(child: Text('Không có dữ liệu'));
            }
            return Column(
              children: [
                TutorHeroWidget(
                  fullName: _teacherData?['account']['fullName'] ?? 'Gia sư không xác định',
                  role: _teacherData?['account']['role'] ?? 'Gia sư',
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
                      Tab(text: 'Hồ sơ'),
                      Tab(text: 'Khóa học'),
                      Tab(text: 'Chứng chỉ'),
                      Tab(text: 'Phản hồi'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _ProfileTab(teacherData: _teacherData!),
                      _CoursesTab(teacherData: _teacherData!),
                      _CertificationsTab(teacherData: _teacherData!),
                      const _FeedbackTab(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Lazy-loaded tabs with AutomaticKeepAliveClientMixin
class _ProfileTab extends StatefulWidget {
  final Map<String, dynamic> teacherData;

  const _ProfileTab({required this.teacherData});

  @override
  __ProfileTabState createState() => __ProfileTabState();
}

class __ProfileTabState extends State<_ProfileTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TutorProfileWidget(
      fullName: widget.teacherData['account']['fullName'] ?? 'Không có thông tin',
      role: widget.teacherData['account']['role'] ?? 'Không có thông tin',
      bio: widget.teacherData['account']['bio'] ??
          'Gia sư giàu kinh nghiệm với đam mê giảng dạy và giúp học sinh thành công.',
      email: widget.teacherData['account']['email'] ?? 'Không có thông tin',
      phone: widget.teacherData['account']['phone'] ?? 'Không có thông tin',
      status: widget.teacherData['account']['status'] ?? 'Không có thông tin',
    );
  }
}

class _CoursesTab extends StatefulWidget {
  final Map<String, dynamic> teacherData;

  const _CoursesTab({required this.teacherData});

  @override
  __CoursesTabState createState() => __CoursesTabState();
}

class __CoursesTabState extends State<_CoursesTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TutorCoursesWidget(courses: widget.teacherData['courses'] ?? []);
  }
}

class _CertificationsTab extends StatefulWidget {
  final Map<String, dynamic> teacherData;

  const _CertificationsTab({required this.teacherData});

  @override
  __CertificationsTabState createState() => __CertificationsTabState();
}

class __CertificationsTabState extends State<_CertificationsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TutorCertificationsWidget(certifications: widget.teacherData['certifications'] ?? []);
  }
}

class _FeedbackTab extends StatefulWidget {
  const _FeedbackTab();

  @override
  __FeedbackTabState createState() => __FeedbackTabState();
}

class __FeedbackTabState extends State<_FeedbackTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const TutorFeedbackWidget();
  }
}