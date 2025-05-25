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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}