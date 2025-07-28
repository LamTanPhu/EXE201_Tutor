import 'package:flutter/material.dart';

class PostCardDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> post;
  final bool isLiking;
  final VoidCallback onLike;
  final String Function(String) formatDate;

  const PostCardDetailsWidget({
    super.key,
    required this.post,
    required this.isLiking,
    required this.onLike,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upvote section (Reddit style)
            Column(
              children: [
                IconButton(
                  onPressed: isLiking ? null : onLike,
                  icon: isLiking
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.arrow_upward, size: 20),
                ),
                Text('${post['numberOfLikes'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 12),
            // Post content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post['title'] ?? 'Không có tiêu đề',
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text("u/${post['fullName'] ?? 'không xác định'}",
                          style: const TextStyle(fontSize: 12.0, color: Colors.grey)),
                      const SizedBox(width: 8.0),
                      Text(formatDate(post['createdAt']),
                          style: const TextStyle(fontSize: 12.0, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(post['content'] ?? 'Không có nội dung',
                      style: const TextStyle(fontSize: 15.0, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}