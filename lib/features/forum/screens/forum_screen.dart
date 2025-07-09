import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/forum/widgets/forum_app_bar_widget.dart';
import 'package:tutor/features/forum/widgets/forum_drawer_widget.dart';
import 'package:tutor/features/forum/widgets/forum_post_list_widget.dart';
import 'package:tutor/features/forum/widgets/create_post_sheet_widget.dart';
import 'package:tutor/features/home/widgets/home_bottom_nav_bar_widget.dart';
import 'package:tutor/routes/app_routes.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  late Future<List<dynamic>> _futurePosts;
  List<dynamic> _posts = [];
  int _selectedIndex = 2; // Default to Forum (index 2)

  @override
  void initState() {
    super.initState();
    _futurePosts = ApiService.getForumPosts().then((data) {
      setState(() {
        _posts = data;
      });
      return _posts;
    }).catchError((error) {
      setState(() {
        _posts = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading posts: $error'),
          backgroundColor: Colors.red,
        ),
      );
      return _posts;
    });
  }

  String _formatDate(String createdAt) {
    final date = DateTime.parse(createdAt);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }

  void _showCreatePostSheet() {
    CreatePostSheetWidget.show(context, (newPost) {
      setState(() {
        _posts.insert(0, newPost);
        _futurePosts = ApiService.getForumPosts(); // Refresh to sync with server
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home, arguments: true);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.home, arguments: false);
        break;
      case 2:
        break;
      case 3: // Overview
        Navigator.pushReplacementNamed(context, AppRoutes.overview);
        break;
      case 4: // Profile
        Navigator.pushNamed(context, AppRoutes.guest);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: ForumAppBarWidget(),
      drawer: ForumDrawerWidget(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 4.0, bottom: 10.0, left: 8.0),
              child: Text(
                'Explore Discussions',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: ForumPostListWidget(_futurePosts, _posts, _formatDate),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreatePostSheet,
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Post', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}