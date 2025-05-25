// features/tutor/tutor_courses_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/models/course_item.dart';
import 'package:tutor/features/tutor/screens/course_creation_screen.dart';
import 'package:tutor/services/api_service.dart';

class TutorCoursesScreen extends StatefulWidget {
  const TutorCoursesScreen({super.key});

  @override
  State<TutorCoursesScreen> createState() => _TutorCoursesScreenState();
}

class _TutorCoursesScreenState extends State<TutorCoursesScreen> {
  late Future<List<CourseItem>> _coursesFuture;

  @override
  void initState() {
    super.initState();
  }


  void _showCourseDetails(BuildContext context, CourseItem courseItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(courseItem.course.name ?? 'Unnamed Course'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (courseItem.course.image != null && courseItem.course.image!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: courseItem.course.image!,
                  width: 100,
                  height: 100,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              const SizedBox(height: 8),
              Text('Description: ${courseItem.course.description ?? 'N/A'}'),
              Text('Price: \$${courseItem.course.price?.toStringAsFixed(2) ?? '0.00'}'),
              Text('Active: ${courseItem.course.isActive != null ? (courseItem.course.isActive! ? 'Yes' : 'No') : 'N/A'}'),
              Text('Created at: ${courseItem.course.createdAt?.toString() ?? 'N/A'}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Courses')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCourseScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Create New Course',
      ),
      body: FutureBuilder<List<CourseItem>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final courseItem = courses[index];
                return ListTile(
                  title: Text(courseItem.course.name ?? 'Unnamed Course'),
                  subtitle: Text(
                    '${courseItem.course.description ?? 'N/A'}\nPrice: \$${courseItem.course.price?.toStringAsFixed(2) ?? '0.00'}',
                  ),
                  leading: courseItem.course.image != null && courseItem.course.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: courseItem.course.image!,
                          width: 50,
                          height: 50,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                      : const Icon(Icons.image),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showCourseDetails(context, courseItem),
                    tooltip: 'View Details',
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No courses found'));
        },
      ),
    );
  }
}