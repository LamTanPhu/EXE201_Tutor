import 'package:flutter/material.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/features/account/widgets/certification_card_widget.dart';
import 'package:tutor/routes/app_routes.dart';

class CertificationsTab extends StatelessWidget {
  final List<Certification> data;

  const CertificationsTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final certifications = data;

    if (certifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified,
              size: 64,
              color: AppColors.subText.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chưa có chứng chỉ nào',
              style: TextStyle(color: AppColors.subText, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to add certification
                Navigator.pushNamed(context, AppRoutes.ceritificationUpload);
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm chứng chỉ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chứng chỉ (${certifications.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Navigate to add certification
                  Navigator.pushNamed(context, AppRoutes.ceritificationUpload);
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Thêm'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: certifications.length,
            itemBuilder: (context, index) {
              return CertificationCard(certification: certifications[index]);
            },
          ),
        ],
      ),
    );
  }
}
