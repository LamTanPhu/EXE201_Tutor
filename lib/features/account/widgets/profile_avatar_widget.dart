import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/theme/app_colors.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final Account profileData;

  const ProfileAvatarWidget({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: AppColors.lightPrimary,
        backgroundImage:
            profileData.avatar != null
                ? NetworkImage(profileData.avatar!)
                : null,
        child:
            profileData.avatar == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
      ),
    );
  }
}
