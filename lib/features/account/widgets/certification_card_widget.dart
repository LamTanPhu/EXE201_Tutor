import 'package:flutter/material.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/theme/app_colors.dart';

class CertificationCard extends StatelessWidget {
  final Certification certification;

  const CertificationCard({super.key, required this.certification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: certification.isCanTeach == true && certification.isChecked == true
                  ? AppColors.primaryGradient
                  : LinearGradient(
                      colors: [
                        AppColors.subText,
                        AppColors.subText.withOpacity(0.7)
                      ],
                    ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              certification.isCanTeach == true && certification.isChecked == true ? Icons.verified : Icons.pending,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  certification.name ?? 'Chứng chỉ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          if (certification.isCanTeach == true && certification.isChecked == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Đã xác thực',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}