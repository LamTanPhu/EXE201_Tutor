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
  bool isLiking = false; // Add loading state for like button
  bool isSubmitting = false; // Add loading state for comment submission

  @override
  void initState() {
    super.initState();
    print('Loading post with ID: ${widget.postId}');
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
    if (isLiking) return; // Prevent double-tapping

    setState(() {
      isLiking = true;
    });

    try {
      print('Attempting to like post with ID: ${widget.postId}');
      final response = await ApiService.likeForumPost(widget.postId);

      // Handle different response structures
      Map<String, dynamic> updatedPost;
      if (response.containsKey('data') && response['data'] != null) {
        updatedPost = response['data'] as Map<String, dynamic>;
      } else {
        updatedPost = response;
      }

      setState(() {
        futurePost = Future.value(updatedPost);
        isLiking = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post liked successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLiking = false;
      });

      print('Error liking post: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to like post: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _submitComment() async {
    if (isSubmitting || commentController.text.isEmpty) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      final response = await ApiService.addForumFeedback(widget.postId, commentController.text);

      setState(() {
        futurePost = ApiService.getForumPostById(widget.postId); // Refresh post data
        commentController.clear();
        isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment added successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isSubmitting = false;
      });

      print('Error submitting comment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add comment: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
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
                onPressed: isSubmitting ? null : _submitComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSubmitting ? Colors.grey : Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: isSubmitting
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text('Submit Comment'),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading post details: ${snapshot.error ?? 'Unknown error'}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futurePost = ApiService.getForumPostById(widget.postId);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
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
                              onPressed: isLiking ? null : _handleLike,
                              icon: isLiking
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : const Icon(Icons.arrow_upward, size: 16.0),
                              label: Text('${post['numberOfLikes'] ?? 0} Likes'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isLiking ? Colors.grey : Colors.green[600],
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
                  const Center(
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
                  ),
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

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}