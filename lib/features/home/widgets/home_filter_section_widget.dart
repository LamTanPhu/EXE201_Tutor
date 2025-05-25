import 'package:flutter/material.dart';

class HomeFilterSectionWidget extends StatelessWidget {
  final String title;
  final Widget content;

  const HomeFilterSectionWidget({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}