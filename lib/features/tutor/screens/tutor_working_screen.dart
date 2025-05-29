import 'package:flutter/material.dart';
import 'package:tutor/routes/app_routes.dart';

class TutorWorkingScreen extends StatelessWidget {
  const TutorWorkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Submit Certification',
        'icon': Icons.upload_file_rounded,
        'route': AppRoutes.ceritificationUpload,
      },
      {
        'title': 'View Certificiations',
        'icon': Icons.check_circle_rounded,
        'route': '/cert-list',
      },
      {
        'title': 'Profile',
        'icon': Icons.person_4_rounded,
        'route': AppRoutes.tutorInfo,
      },{
        'title': 'Courses',
        'icon': Icons.book_online_rounded,
        'route': AppRoutes.courseCreate,
      },
    ];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
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
            ),
          );
        },
      ),
    );
  }
}
