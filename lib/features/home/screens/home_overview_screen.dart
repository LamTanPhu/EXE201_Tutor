import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/home/widgets/home_grid_item_widget.dart';
import 'package:tutor/features/home/widgets/home_bottom_nav_bar_widget.dart';
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
      appBar: AppBar(
        title: const Text(
          'Tutor Platform',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF4A90E2)),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.aboutUs);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4A90E2),
                strokeWidth: 6,
              ),
            )
          else
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
                          const Text(
                            'Welcome to Your Learning Journey',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Discover top courses and engaging discussions to enhance your skills.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Featured Course',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return HomeGridItemWidget(
                                item: {
                                  'course': _featuredCourse?['course'],
                                  'account': {'fullName': _featuredCourse?['account']['fullName']},
                                },
                                isTeacherMode: false,
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
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Trending Forum Post',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _trendingPost == null
                              ? const Center(
                            child: Text(
                              'No trending post available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                              : Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.forumDetails,
                                  arguments: _trendingPost['_id'],
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _trendingPost['title'] ?? 'No Title',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _trendingPost['content'] ?? 'No Content',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Top Learner',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _topAccount == null ||
                              _topAccount['fullName'] == null ||
                              _topAccount['email'] == null
                              ? Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'No top learner available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                              : Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.guest,
                                  arguments: _topAccount['email'],
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _topAccount['fullName'] ?? 'Unknown User',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _topAccount['email'] ?? 'No Email',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Completed Courses: ${_topAccount['completedCourses'] ?? 0}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
        ],
      ),
      bottomNavigationBar: HomeBottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}