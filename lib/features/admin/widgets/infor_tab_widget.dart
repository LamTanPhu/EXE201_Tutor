import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/theme/app_colors.dart';

class InfoTabWidget extends StatelessWidget {
  final Account account;

  const InfoTabWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard([
            _buildInfoRow('Họ và tên', account.fullName ?? "Chưa có thông tin", Icons.person),
            _buildInfoRow('Email', account.email ?? "Chưa có thông tin", Icons.email),
            _buildInfoRow('Số điện thoại', account.phone ?? "Chưa có thông tin", Icons.phone),
            _buildInfoRow('Vai trò', account.role ?? "Chưa có thông tin", Icons.work),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      color: AppColors.card,
      elevation: 4,
      shadowColor: AppColors.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.card,
              AppColors.backgroundGradientStart.withOpacity(0.2),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.subText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}