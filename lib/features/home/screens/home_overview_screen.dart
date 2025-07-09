import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/home/widgets/home_grid_item_widget.dart';
import 'package:tutor/features/home/widgets/home_bottom_nav_bar_widget.dart';
import 'package:tutor/features/home/widgets/overview/header_widget.dart';
import 'package:tutor/features/home/widgets/overview/welcome_section_widget.dart';
import 'package:tutor/features/home/widgets/overview/featured_course_section_widget.dart';
import 'package:tutor/features/home/widgets/overview/trending_post_section_widget.dart';
import 'package:tutor/features/home/widgets/overview/top_learner_section_widget.dart';
import 'package:tutor/features/home/widgets/overview/loading_overlay_widget.dart';
import 'package:tutor/routes/app_routes.dart';

class HomeOverviewScreen extends StatefulWidget {
  const HomeOverviewScreen({super.key});

  @override
  State<HomeOverviewScreen> createState() => _HomeOverviewScreenState();
}

class _HomeOverviewScreenState extends State<HomeOverviewScreen> {
  dynamic _featuredCourse;
  dynamic _trendingPost;
  dynamic _topAccount;
  bool _isLoading = true;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  int _selectedIndex = 3; // Initialized to 3 (Overview)

  @override
  void initState() {
    super.initState();
    _fetchOverviewData();
  }

  Future<void> _fetchOverviewData() async {
    if (_retryCount >= _maxRetries) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load data after multiple retries')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final coursesData = await ApiService.getCourses();
      final courses = coursesData['data']['courses'] ?? [];
      final posts = await ApiService.getForumPosts();
      final topAccountData = await ApiService.getTopAccountReport();
      print('Top Account Raw Response: $topAccountData'); // Debug log
      setState(() {
        _featuredCourse = courses.isNotEmpty ? courses.first : null;
        _trendingPost = posts.isNotEmpty ? posts.first : null;
        _topAccount = topAccountData != null && topAccountData is Map ? topAccountData : null;
        _isLoading = false;
      });
    } catch (e) {
      print('Fetch Overview Data Error: $e'); // Debug log
      setState(() {
        _retryCount++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e. Retrying ($_retryCount/$_maxRetries)...'),
          action: _retryCount < _maxRetries
              ? SnackBarAction(
            label: 'Retry',
            onPressed: _fetchOverviewData,
          )
              : null,
        ),
      );
      if (_retryCount < _maxRetries) {
        await Future.delayed(const Duration(seconds: 2));
        await _fetchOverviewData();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0: // Tutor mode
        Navigator.pushReplacementNamed(context, AppRoutes.home, arguments: true);
        break;
      case 1: // Course mode
        Navigator.pushReplacementNamed(context, AppRoutes.home, arguments: false);
        break;
      case 2: // Forum
        Navigator.pushNamed(context, AppRoutes.forum);
        break;
      case 3: // Overview (current screen, no action)
        break;
      case 4: // Profile
        Navigator.pushNamed(context, AppRoutes.guest);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderWidget(),
      body: Stack(
        children: [
          Builder(
            builder: (context) {
              try {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFB0C4DE), Color(0xFFF5F6F5)],
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WelcomeSectionWidget(),
                        const SizedBox(height: 30),
                        FeaturedCourseSectionWidget(
                          course: _featuredCourse,
                          onTap: () {
                            if (_featuredCourse != null) {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.courseDetails,
                                arguments: {
                                  'courseId': _featuredCourse['course']['_id'],
                                  'courseData': {'course': _featuredCourse['course']},
                                },
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        TrendingPostSectionWidget(
                          post: _trendingPost,
                          onTap: () {
                            if (_trendingPost != null) {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.forumDetails,
                                arguments: _trendingPost['_id'],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        TopLearnerSectionWidget(
                          account: _topAccount,
                          onTap: () {
                            if (_topAccount != null && _topAccount['email'] != null) {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.guest,
                                arguments: _topAccount['email'],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } catch (e, stackTrace) {
                print('Render Error in HomeOverviewScreen: $e\n$stackTrace'); // Debug log
                return const Center(
                  child: Text(
                    'Error loading content. Please try again.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
            },
          ),
          LoadingOverlayWidget(isLoading: _isLoading),
        ],
      ),
      bottomNavigationBar: HomeBottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}