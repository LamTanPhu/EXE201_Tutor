import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';

import '../../../../routes/app_routes.dart';

class CourseChapters extends StatelessWidget {
  final String courseId;

  const CourseChapters({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.getCourseChapters(courseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có chương nào'));
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
                  'Các chương',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return FutureBuilder<List<dynamic>>(
                      future: ApiService.getChapterContent(chapter['_id'] as String),
                      builder: (context, contentSnapshot) {
                        String content = 'Chưa có nội dung.';
                        if (contentSnapshot.connectionState == ConnectionState.done &&
                            contentSnapshot.hasData &&
                            contentSnapshot.data!.isNotEmpty) {
                          content = contentSnapshot.data![0]['contentDescription'] ?? 'Không có nội dung';
                        }
                        return _ChapterItem(
                          chapter: chapter,
                          chapterNumber: index + 1,
                          content: content,
                          chapterId: chapter['_id'] as String,
                        );
                      },
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

class _ChapterItem extends StatefulWidget {
  final Map<String, dynamic> chapter;
  final int chapterNumber;
  final String content;
  final String chapterId;

  const _ChapterItem({
    required this.chapter,
    required this.chapterNumber,
    required this.content,
    required this.chapterId,
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
        child: Text('${widget.chapterNumber}'),
      ),
      title: Text(widget.chapter['title'] ?? 'Chương không có tiêu đề'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.content,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.chapterDetails,
                    arguments: widget.chapterId,
                  );
                },
                child: const Text('Xem chi tiết'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}