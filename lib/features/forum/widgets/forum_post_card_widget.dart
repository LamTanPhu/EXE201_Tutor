import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';

class ForumPostCardWidget extends StatelessWidget {
  final dynamic post;
  final String Function(String) formatDate;

  const ForumPostCardWidget({required this.post, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.forumDetails,
          arguments: post['_id'],
        );
      },
      child: Card(
        color: Colors.blue[50],
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['title'] ?? 'Không có tiêu đề',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.person, size: 16.0),
                  const SizedBox(width: 4.0),
                  Text(
                    post['fullName'] ?? 'Không xác định',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    formatDate(post['createdAt']),
                    style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                post['content'] ?? 'Không có nội dung',
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () {
                      // Implement upvote
                    },
                  ),
                  Text('${post['numberOfLikes'] ?? 0}'),
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.forumDetails,
                        arguments: post['_id'],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}