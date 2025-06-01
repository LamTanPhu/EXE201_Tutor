import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';

class CourseChapters extends StatelessWidget {
  final String courseId;

  const CourseChapters({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.getCourseChapters(courseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No chapters available'));
        }

        final chapters = snapshot.data!;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chapters',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'), // Chapter number (position)
                      ),
                      title: Text(chapter['title'] ?? 'Untitled Chapter'),
                      onTap: () {
                        // TODO: Navigate to chapter content
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}