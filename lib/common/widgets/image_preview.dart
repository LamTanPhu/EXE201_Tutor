import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final String? imageFile;
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
    ImageProvider? imageProvider;
    if (imageFile != null && imageFile!.isNotEmpty) {
      if (imageFile!.startsWith('http')) {
        imageProvider = NetworkImage(imageFile!);
      } else if (!kIsWeb) {
        imageProvider = FileImage(File(imageFile!));
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
          image: imageProvider != null
              ? DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageProvider == null
            ? const Center(child: Text('Tap to pick image'))
            : null,
      ),
    );
  }
}