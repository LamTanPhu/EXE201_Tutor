import 'package:flutter/material.dart';
import 'package:tutor/features/details/widgets/course_widgets/course_header.dart';
import 'package:tutor/features/details/widgets/course_widgets/course_description.dart';
import 'package:tutor/features/details/widgets/course_widgets/course_chapters.dart';

// Hardcoded course data (to be replaced with API later)
const Map<String, dynamic> defaultCourseData = {
  "course": {
    "name": "Flutter Advanced Course",
    "image": "https://example.com/course.jpg",
    "price": "1500000",
    "description": "Learn advanced Flutter techniques for building modern apps.",
    "isActive": true,
    "createdAt": "2023-10-01",
    "instructor": "John Doe",
    "duration": "10 hours"
  }
};

class CourseDetailsScreen extends StatelessWidget {
  final String courseId;
  final Map<String, dynamic>? courseData;

  const CourseDetailsScreen({super.key, required this.courseId, this.courseData});

  @override
  Widget build(BuildContext context) {
    // Debug print to verify courseId
    print('Received courseId: $courseId');

    // Use provided courseData or fallback to default
    final course = courseData?['course'] ?? defaultCourseData['course'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseHeader(course: course),
            const SizedBox(height: 16),
            CourseDescription(description: course['description'] ?? 'No description available'),
            const SizedBox(height: 16),
            CourseChapters(courseId: courseId),
            const SizedBox(height: 16),
            // Additional Info
            ListTile(
              title: const Text('Status'),
              subtitle: Text(course['isActive'] == true ? 'Active' : 'Inactive'),
              leading: const Icon(Icons.info),
            ),
            ListTile(
              title: const Text('Duration'),
              subtitle: Text(course['duration'] ?? 'N/A'),
              leading: const Icon(Icons.timer),
            ),
            ListTile(
              title: const Text('Created At'),
              subtitle: Text(course['createdAt'] ?? 'N/A'),
              leading: const Icon(Icons.calendar_today),
            ),
            const SizedBox(height: 16),
            // Enroll Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement enroll functionality
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Enroll Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}