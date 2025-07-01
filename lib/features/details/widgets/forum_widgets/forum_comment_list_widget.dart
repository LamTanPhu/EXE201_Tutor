import 'package:flutter/material.dart';

class CommentListWidget extends StatelessWidget {
  final List<dynamic> feedback;
  final String Function(String) formatDate;

  const CommentListWidget({
    super.key,
    required this.feedback,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    if (feedback.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.comment_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text('No comments yet', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Column(
      children: feedback.map((comment) {
        return Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size: 16.0, color: Colors.grey),
                    const SizedBox(width: 4.0),
                    Text(comment['fullName'] ?? 'Unknown', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(width: 8.0),
                    Text(formatDate(comment['createdAt']), style: const TextStyle(fontSize: 12.0, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(comment['reply'] ?? 'No content', style: const TextStyle(fontSize: 14.0, color: Colors.black54)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
