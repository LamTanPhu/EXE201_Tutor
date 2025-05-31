import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final File? imageFile;
  final double height;
  final double width;
  final VoidCallback? onTap;

  const ImagePreviewWidget({
    super.key,
    required this.imageFile,
    this.height = 150,
    this.width = double.infinity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
          image: imageFile != null
              ? DecorationImage(
                  image: FileImage(imageFile!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageFile == null
            ? const Center(child: Text('Tap to pick image'))
            : null,
      ),
    );
  }
}
