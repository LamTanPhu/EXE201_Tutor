import 'package:flutter/material.dart';
import 'package:tutor/common/theme/app_colors.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: 16),
            Text(
              'Đang tải dữ liệu...',
              style: TextStyle(
                color: AppColors.subText,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}