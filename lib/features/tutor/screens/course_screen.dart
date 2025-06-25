import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/currency.dart';
import 'package:tutor/features/tutor/screens/course_creation_screen.dart';
import 'package:tutor/features/tutor/screens/course_detail_screen.dart';
import 'package:tutor/services/api_service.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late Future<List<Course>> _coursesFuture;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchCourses();
  }

  Future<List<Course>> _fetchCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accountId = prefs.getString('accountId');
      if (accountId == null) {
        throw Exception('Account ID not found');
      }
      final response = await ApiService.getAccountDetails(accountId);

      // Check if response['data'] and response['data']['courses'] exist
      if (response['data'] == null || response['data']['courses'] == null || response['data']['courses'] is! List) {
        return []; // Return empty list if courses is null or not a list
      }

      // Safely map the courses
      final List<Course> courses = (response['data']['courses'] as List<dynamic>)
          .map<Course>((course) {
            return Course.fromJson(course);
          })
          .toList();
      return courses;
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  void _refreshCourses() {
    setState(() {
      _coursesFuture = _fetchCourses();
    });
  }

  void _goToCourseCreation() async {
    final newCourse = await Navigator.push<Course>(
      context,
      MaterialPageRoute(builder: (_) => const CreateCourseScreen()),
    );
    if (newCourse != null) {
      _refreshCourses(); // Refresh the course list after adding a new course
    }
  }


  List<Course> _filteredCourses(List<Course> courses) {
    if (_searchText.isEmpty) return courses;
    return courses
        .where((c) => c.name.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Các khoá học của tôi',
          style: TextStyle(color: AppColors.primary),
        ),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Course>>(
              future: _coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }

                final courses = snapshot.data ?? [];
                final filteredCourses = _filteredCourses(courses);

                if (filteredCourses.isEmpty) {
                  return const Center(child: Text('K.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    return Card(
                      elevation: 3,
                      color: AppColors.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailScreen(course: course),
                            ),
                          );
                        },
                        leading: course.image.isNotEmpty
                            ? Image.network(
                                course.image,
                                width: 40,
                                height: 20,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.book,
                                        color: AppColors.primary),
                              )
                            : const Icon(Icons.book, color: AppColors.primary),
                        title: Text(
                          course.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(course.description),
                        trailing: Text(
                          CurrencyUtils.formatVND(course.price),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCourseCreation,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
    );
  }
}