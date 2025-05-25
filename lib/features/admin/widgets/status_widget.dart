// features/reports/widgets/course_status_widget.dart
import 'package:flutter/material.dart';
import 'package:tutor/common/models/statistic_data.dart';
import 'package:tutor/services/api_service.dart';

class CourseStatusWidget extends StatefulWidget {
  const CourseStatusWidget({super.key});

  @override
  State<CourseStatusWidget> createState() => _CourseStatusWidgetState();
}

class _CourseStatusWidgetState extends State<CourseStatusWidget> {
  late Future<StatusData> _statusFuture;

  @override
  void initState() {
    super.initState();
    _statusFuture = ApiService.getCourseStatusReport();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Course Status Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<StatusData>(
              future: _statusFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.statuses.isNotEmpty) {
                  final statuses = snapshot.data!.statuses;
                  return Column(
                    children: statuses.entries.map((entry) {
                      return ListTile(
                        title: Text(entry.key),
                        trailing: Text('${entry.value} courses'),
                      );
                    }).toList(),
                  );
                }
                return const Text('No course status data available');
              },
            ),
          ],
        ),
      ),
    );
  }
}