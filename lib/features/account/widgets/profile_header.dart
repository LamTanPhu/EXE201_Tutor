import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/currency.dart';
import 'package:tutor/features/account/widgets/profile_avatar_widget.dart';

class ProfileHeader extends StatelessWidget {
  final Account profileData;

  const ProfileHeader({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0, -50, 0),
      child: Column(
        children: [
          ProfileAvatarWidget(profileData: profileData),
          const SizedBox(height: 16),
          Text(
            profileData.fullName ?? 'Chưa cập nhật',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              CurrencyUtils.formatVND(profileData.balance ?? 0),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
