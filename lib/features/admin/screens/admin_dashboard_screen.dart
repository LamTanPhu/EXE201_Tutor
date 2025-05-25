import 'package:flutter/material.dart';
import 'package:tutor/routes/app_routes.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': "Approve Certifications",
        'icon': Icons.verified_rounded,
        'route': AppRoutes.certifApprove,
      },
      {
        'title': 'Manage Courses',
        'icon': Icons.book_rounded,
        'route': AppRoutes.allCourses,
      },
      {
        'title': 'Reports & Statistics',
        'icon': Icons.bar_chart_rounded,
        'route': AppRoutes.reports,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,),
          itemBuilder: (context, index){
            final item = items[index];

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, item['route'] as String);
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData, size: 40),
                    const SizedBox(height: 8),
                    Text(item['title'] as String),
                  ],
                ),
              )
            );
          },
        ),
      ),
    );
  }
}
