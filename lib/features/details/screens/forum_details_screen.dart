import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/forum/widgets/forum_app_bar_widget.dart';
import 'package:tutor/features/details/widgets/forum_widgets/forum_post_card_details_widget.dart';
import 'package:tutor/features/details/widgets/forum_widgets/forum_comment_list_widget.dart';
import 'package:tutor/features/details/widgets/forum_widgets/add_comment_sheet_widget.dart';
import '../widgets/forum_widgets/add_comment_widget.dart';

class ForumDetailsScreen extends StatefulWidget {
  final String postId;

  const ForumDetailsScreen({super.key, required this.postId});

  @override
  ForumDetailsScreenState createState() => ForumDetailsScreenState();
}

class ForumDetailsScreenState extends State<ForumDetailsScreen> {
  late Future<Map<String, dynamic>> futurePost;
  final TextEditingController commentController = TextEditingController();
  bool isLiking = false;
  bool isSubmitting = false;

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
    if (isLiking) return;

    setState(() => isLiking = true);

    try {
      // final response = await ApiService.likeForumPost(widget.postId);
      // final updatedPost = response['data'] ?? response;
      //
      // setState(() {
      //   futurePost = Future.value(updatedPost);
      //   isLiking = false;
      // });
      await ApiService.likeForumPost(widget.postId);

      setState(() {
        futurePost = ApiService.getForumPostById(widget.postId);
        isLiking = false;
      });

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
      setState(() => isLiking = false);
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

    setState(() => isSubmitting = true);

    try {
      await ApiService.addForumFeedback(widget.postId, commentController.text);
      setState(() {
        futurePost = ApiService.getForumPostById(widget.postId);
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
      setState(() => isSubmitting = false);
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
        return AddCommentSheetWidget(
          controller: commentController,
          onSubmit: _submitComment,
          isSubmitting: isSubmitting,
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

          return Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 160),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PostCardDetailsWidget(
                          post: post,
                          isLiking: isLiking,
                          onLike: _handleLike,
                          formatDate: formatDate,
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
                        CommentListWidget(
                          feedback: feedback,
                          formatDate: formatDate,
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: AddCommentSectionWidget(
                    controller: commentController,
                    onSubmit: _submitComment,
                    isSubmitting: isSubmitting,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // Uncomment to use modal instead of inline:
      // floatingActionButton: FloatingActionButton(
      //   onPressed: showAddCommentSheet,
      //   backgroundColor: Colors.blue[700],
      //   child: const Icon(Icons.comment, color: Colors.white),
      // ),
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
