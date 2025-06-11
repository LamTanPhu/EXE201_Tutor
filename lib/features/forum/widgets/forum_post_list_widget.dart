import 'package:flutter/material.dart';
import 'package:tutor/features/forum/widgets/forum_post_card_widget.dart';

class ForumPostListWidget extends StatelessWidget {
  final Future<List<dynamic>> futurePosts;
  final List<dynamic> posts;
  final String Function(String) formatDate;

  const ForumPostListWidget(this.futurePosts, this.posts, this.formatDate);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || posts.isEmpty) {
          return const Center(child: Text('No posts available'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ForumPostCardWidget(post: post, formatDate: formatDate);
            },
          );
        }
      },
    );
  }
}