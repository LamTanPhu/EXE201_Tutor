import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? avatarUrl;

  const ProfileAvatarWidget({super.key, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 60,
      backgroundImage: NetworkImage(
        avatarUrl ?? 'https://icons8.com/icon/nXduhA13SMUu/person',
      ),
      backgroundColor: Colors.grey[200] ,
    );
  }
}