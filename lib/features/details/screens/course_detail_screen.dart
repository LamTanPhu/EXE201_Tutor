import 'package:flutter/material.dart';

class CourseDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? courseData;

  const CourseDetailsScreen({super.key, this.courseData});

  @override
  Widget build(BuildContext context) {
    // Use the passed course data
    final course = courseData?['course'] ?? {'name': 'Unknown Course'};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            course['image'] != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                course['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.network('https://via.placeholder.com/150'),
              ),
            )
                : const SizedBox.shrink(),
            const SizedBox(height: 16),

            // Course Title
            Text(
              course['name'] ?? 'Unknown Course',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),

            // Course Price
            Text(
              'Price: ${course['price'] ?? 'N/A'} VND',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),

            // Course Description
            Text(
              course['description'] ?? 'No description available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),

            // Course Status
            Text(
              'Status: ${course['isActive'] == true ? 'Active' : 'Inactive'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),

            // Created At
            Text(
              'Created At: ${course['createdAt'] ?? 'N/A'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}