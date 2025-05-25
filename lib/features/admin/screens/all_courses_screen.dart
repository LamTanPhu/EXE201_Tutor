import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/models/course_item.dart';
import 'package:tutor/services/api_service.dart';

class GetAllCoursesScreen extends StatefulWidget {
  const GetAllCoursesScreen({super.key});

  @override
  State<GetAllCoursesScreen> createState() => _GetAllCoursesScreenState();
}

class _GetAllCoursesScreenState extends State<GetAllCoursesScreen> {
  late Future<List<CourseItem>> _coursesFuture;

@override
  void initState() {
    super.initState();
    _coursesFuture = ApiService.getAllCourses();
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
              Text('Created by: ${courseItem.account.fullName ?? 'Unknown'}'),
              Text('Email: ${courseItem.account.email ?? 'N/A'}'),
              Text('Active: ${courseItem.course.isActive != null ? (courseItem.course.isActive! ? 'Yes' : 'No') : 'N/A'}'),
              Text('Created at: ${courseItem.course.createdAt?.toString() ?? 'N/A'}'),
              const SizedBox(height: 8),
              const Text('Certifications:', style: TextStyle(fontWeight: FontWeight.bold)),
              if (courseItem.certifications.isNotEmpty)
                ...courseItem.certifications.map(
                  (cert) => Text('- ${cert.name ?? 'Unnamed'} (${cert.description ?? 'N/A'})'),
                )
              else
                const Text('No certifications'),
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
      appBar: AppBar(title: const Text('All Courses')),
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