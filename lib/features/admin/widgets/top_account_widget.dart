// features/reports/widgets/top_account_widget.dart
import 'package:flutter/material.dart';
import 'package:tutor/common/models/statistic_data.dart';
import 'package:tutor/services/api_service.dart';

class TopAccountWidget extends StatefulWidget {
  const TopAccountWidget({super.key});

  @override
  State<TopAccountWidget> createState() => _TopAccountWidgetState();
}

class _TopAccountWidgetState extends State<TopAccountWidget> {
  late Future<TopAccount> _topAccountFuture;

  @override
  void initState() {
    super.initState();
    _topAccountFuture = ApiService.getTopAccountReport();
  }

  void _showAccountDetails(BuildContext context, TopAccount account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(account.fullName ?? 'Unknown Account'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email: ${account.email ?? 'N/A'}'),
              Text('Completed Courses: ${account.completedCourses ?? 0}'),
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
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Account Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<TopAccount>(
              future: _topAccountFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final account = snapshot.data!;
                  return ListTile(
                    title: Text(account.fullName ?? 'Unknown'),
                    subtitle: Text('Completed Courses: ${account.completedCourses ?? 0}'),
                    onTap: () => _showAccountDetails(context, account),
                  );
                }
                return const Text('No top account available');
              },
            ),
          ],
        ),
      ),
    );
  }
}