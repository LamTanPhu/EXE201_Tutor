// Info Tab Widget
import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/features/account/widgets/info_item.dart';
import 'package:tutor/features/account/widgets/logout_button.dart';

class InfoTab extends StatelessWidget {
  final Account profileData;

  const InfoTab({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          InfoItem(
            icon: Icons.email,
            label: 'Email',
            value: profileData.email ?? 'Chưa cập nhật',
          ),
          InfoItem(
            icon: Icons.phone,
            label: 'Số điện thoại',
            value: profileData.phone ?? 'Chưa cập nhật',
          ),
          const Spacer(),
          LogoutButton(),
        ],
      ),
    );
  }
}