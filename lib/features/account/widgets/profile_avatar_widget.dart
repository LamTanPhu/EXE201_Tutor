import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? avatarUrl;

  const ProfileAvatarWidget({super.key, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
return CircleAvatar(
      radius: 50,
      backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
          ? NetworkImage(avatarUrl!)
          : const AssetImage('assets/avatar.svg') as ImageProvider,
    );
  }
}