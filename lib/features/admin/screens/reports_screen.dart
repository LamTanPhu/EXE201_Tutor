import 'package:flutter/material.dart';
import 'package:tutor/common/models/statistic_data.dart';
import 'package:tutor/common/widgets/dashboard_card.dart';
import 'package:tutor/features/admin/widgets/revenue_widget.dart';
import 'package:tutor/features/admin/widgets/status_widget.dart';
import 'package:tutor/features/admin/widgets/top_account_widget.dart';
import 'package:tutor/services/api_service.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  Future<DashboardCombinedData> fetchDashboardData() async {
    try {
      final results = await Future.wait([
        ApiService.getAccountStatusReport(),
        ApiService.getCourseStatusReport(),
      ]);

      return DashboardCombinedData(
        accountStatus: results[0],
        courseStatus: results[1],
      );
    } catch (e) {
      throw Exception('Failed to load dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(title: const Text('Reports Dashboard')),
      body: FutureBuilder<DashboardCombinedData>(
        future: fetchDashboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          final stats = [
            DashboardStat(
              title: 'Total Accounts',
              value: data.accountStatus.active,
              icon: Icons.person,
            ),
            DashboardStat(
              title: 'Total Courses',
              value: data.courseStatus.active,
              icon: Icons.book,
            ),
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: stats
                      .map((stat) => SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 16,
                            child: DashboardCard(stat: stat),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),
                RevenueWidget(year: currentYear),
                const SizedBox(height: 24),
                const TopAccountWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
