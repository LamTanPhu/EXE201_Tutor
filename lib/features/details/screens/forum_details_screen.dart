import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/forum/widgets/forum_app_bar_widget.dart';
import 'package:tutor/features/forum/widgets/forum_post_card_widget.dart';

class ForumDetailsScreen extends StatefulWidget {
  final String postId;

  const ForumDetailsScreen({super.key, required this.postId});

  @override
  ForumDetailsScreenState createState() => ForumDetailsScreenState();
}

class ForumDetailsScreenState extends State<ForumDetailsScreen> {
  late Future<Map<String, dynamic>> futurePost;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futurePost = ApiService.getForumPostById(widget.postId);
  }

  String formatDate(String createdAt) {
    final date = DateTime.parse(createdAt);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }

  Future<void> _handleLike() async {
    try {
      final response = await ApiService.likeForumPost(widget.postId);
      setState(() {
        futurePost = Future.value(response['data']);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to like post: $e')),
      );
    }
  }

  void showAddCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Comment',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (commentController.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Comment submission not implemented yet')),
                    );
                    commentController.clear();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a comment')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: const Text('Submit Comment'),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ForumAppBarWidget(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futurePost,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading post details'));
          }

          final post = snapshot.data!;
          final feedback = post['feedback'] as List<dynamic>? ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['title'] ?? 'No title',
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 16.0, color: Colors.grey),
                            const SizedBox(width: 4.0),
                            Text(
                              post['fullName'] ?? 'Unknown',
                              style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              formatDate(post['createdAt']),
                              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          post['content'] ?? 'No content',
                          style: const TextStyle(fontSize: 16.0, color: Colors.black54),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _handleLike,
                              icon: const Icon(Icons.arrow_upward, size: 16.0),
                              label: Text('${post['numberOfLikes'] ?? 0} Likes'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Comments (${feedback.length})',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8.0),
                if (feedback.isEmpty)
                  const Center(child: Text('No comments yet', style: TextStyle(color: Colors.grey))),
                ...feedback.map((comment) => Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
                            Text(
                              comment['fullName'] ?? 'Unknown',
                              style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              formatDate(comment['createdAt']),
                              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          comment['reply'] ?? 'No content',
                          style: const TextStyle(fontSize: 14.0, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddCommentSheet,
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.comment, color: Colors.white),
        elevation: 6.0,
      ),
    );
  }
}