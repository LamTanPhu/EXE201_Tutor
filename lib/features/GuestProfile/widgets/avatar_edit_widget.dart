import 'dart:io';
import 'package:flutter/material.dart';

class AvatarEditorWidget extends StatelessWidget {
  final ImageProvider? imageProvider;
  final VoidCallback onEditPressed;
  final bool isEditing;

  const AvatarEditorWidget({
    super.key,
    required this.imageProvider,
    required this.onEditPressed,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          backgroundImage: imageProvider,
          child: imageProvider == null
              ? const Icon(Icons.person, size: 60, color: Colors.grey)
              : null,
        ),
        if (isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                onPressed: onEditPressed,
              ),
            ),
          ),
      ],
    );
  }
}
