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
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'] ?? 'No title',
              style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.person, size: 16.0, color: Colors.grey),
                const SizedBox(width: 4.0),
                Text(post['fullName'] ?? 'Unknown', style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 8.0),
                Text(formatDate(post['createdAt']), style: const TextStyle(fontSize: 12.0, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(post['content'] ?? 'No content', style: const TextStyle(fontSize: 16.0, color: Colors.black54)),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: isLiking ? null : onLike,
                  icon: isLiking
                      ? const SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
                      : const Icon(Icons.arrow_upward, size: 16.0),
                  label: Text('${post['numberOfLikes'] ?? 0} Likes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLiking ? Colors.grey : Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
