import 'package:flutter/material.dart';

class WelcomeSectionWidget extends StatelessWidget {
  const WelcomeSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chào mừng bạn đến với hành trình học tập',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Khám phá các khóa học hàng đầu và những cuộc thảo luận hấp dẫn để nâng cao kỹ năng của bạn.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}