import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';

class CourseChapters extends StatelessWidget {
  final String courseId;

  const CourseChapters({super.key, required this.courseId});

  // Hardcoded chapter content (to be replaced with API later)
  Map<String, String> _getHardcodedContent(String chapterId) {
    return {
      "683c067d2ce769793e7b68df": "This is the content for Chapter 1. It covers the basics of the topic with some detailed explanations and examples to help you get started. Feel free to explore and learn!",
      "683c06982ce769793e7b68e3": "This is the content for Chapter 2. It dives deeper into advanced concepts, including practical applications and tips for mastering the subject. Enjoy your learning journey!",
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.getCourseChapters(courseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No chapters available'));
        }

        final chapters = snapshot.data!;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chapters',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return _ChapterItem(
                      chapter: chapter,
                      chapterNumber: index + 1,
                      content: _getHardcodedContent(chapter['_id'] as String)[chapter['_id']] ??
                          'No content available yet.',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Separate StatefulWidget for each chapter item to manage expansion state
class _ChapterItem extends StatefulWidget {
  final Map<String, dynamic> chapter;
  final int chapterNumber;
  final String content;

  const _ChapterItem({
    required this.chapter,
    required this.chapterNumber,
    required this.content,
  });

  @override
  _ChapterItemState createState() => _ChapterItemState();
}

class _ChapterItemState extends State<_ChapterItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _arrowAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion(bool isExpanded) {
    if (isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(
        child: Text('${widget.chapterNumber}'), // Chapter number (position)
      ),
      title: Text(widget.chapter['title'] ?? 'Untitled Chapter'),
      trailing: RotationTransition(
        turns: _arrowAnimation,
        child: const Icon(Icons.expand_more),
      ),
      onExpansionChanged: (expanded) {
        _toggleExpansion(expanded);
      },
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            widget.content,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}