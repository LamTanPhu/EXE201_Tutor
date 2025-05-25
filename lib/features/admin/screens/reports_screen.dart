// features/reports/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:tutor/features/admin/widgets/revenue_widget.dart';
import 'package:tutor/features/admin/widgets/status_widget.dart';
import 'package:tutor/features/admin/widgets/top_account_widget.dart';


class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports Dashboard')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RevenueWidget(year: DateTime.now().year),
            const CourseStatusWidget(),
            const TopAccountWidget(),
          ],
        ),
      ),
    );
  }
}