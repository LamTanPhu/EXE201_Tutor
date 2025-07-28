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
              Text('Chưa có bình luận', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Column(
      children: feedback.map((comment) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(comment['fullName'] ?? 'Không xác định',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text(formatDate(comment['createdAt']),
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(comment['reply'] ?? '',
                        style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}