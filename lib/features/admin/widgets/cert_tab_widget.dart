import 'package:flutter/material.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/theme/app_colors.dart';

class CertsTabWidget extends StatelessWidget {
  final List<Certification> certifications;

  const CertsTabWidget({super.key, required this.certifications});

  @override
  Widget build(BuildContext context) {
    if (certifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 64, color: AppColors.subText),
            SizedBox(height: 16),
            Text(
              "Không có chứng chỉ",
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: certifications.length,
      itemBuilder: (context, index) {
        final cert = certifications[index];
        return Card(
          color: AppColors.card,
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.card,
                  AppColors.backgroundGradientStart.withOpacity(0.2),
                ],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: AppColors.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cert.name ?? 'Chứng chỉ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.text,
                        ),
                      ),
                      if (cert.description != null && cert.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          cert.description!,
                          style: const TextStyle(
                            color: AppColors.subText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}