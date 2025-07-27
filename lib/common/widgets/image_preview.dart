import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/theme/app_colors.dart';

class ImagePreviewWidget extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final VoidCallback? onTap;
  final bool isLoading;

  const ImagePreviewWidget({
    super.key,
    this.imageUrl,
    this.height = 150,
    this.width = double.infinity,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      ImageProvider imageProvider;
      if (imageUrl!.startsWith('http')) {
        imageProvider = NetworkImage(imageUrl!);
      } else if (!kIsWeb) {
        imageProvider = FileImage(File(imageUrl!));
      } else {
        imageProvider = const AssetImage('assets/placeholder.png'); // Fallback for web
      }

      content = DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              print('Image load error: $exception');
            },
          ),
        ),
      );
    } else {
      content = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload_rounded,
              color: AppColors.primary,
              size: 24,
            ),
            SizedBox(height: 8),
            Text(
              'Tải lên hình ảnh',
              style: TextStyle(
                color: AppColors.subText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: content,
        ),
      ),
    );
  }
}