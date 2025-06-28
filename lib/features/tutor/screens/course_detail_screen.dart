import 'package:flutter/material.dart';
import 'package:tutor/common/models/chapter.dart';
import 'package:tutor/common/models/content.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/services/api_service.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Future<List<Chapter>> _chaptersFuture;
  final _chapterTitleController = TextEditingController();
  final _contentDescriptionController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chaptersFuture = _fetchChapters();
  }

  //fetch chapters for the course
  Future<List<Chapter>> _fetchChapters() async {
    try {
      if (widget.course.id.isEmpty) {
        throw Exception('Course ID is empty');
      }
      final response = await ApiService.getCourseChapters(widget.course.id);
      final List<Chapter> chapters =
          (response as List<dynamic>)
              .map<Chapter>((chapter) => Chapter.fromJson(chapter))
              .toList();
      return chapters;
    } catch (e) {
      throw Exception('Failed to fetch chapters: $e');
    }
  }

  //fetch contents
  Future<List<Content>> _fetchContents(String chapterId) async {
    try {
      if (chapterId.isEmpty) {
        throw Exception('Chapter ID is empty');
      }
      final response = await ApiService.getChapterContent(chapterId);
      final List<Content> contents =
          (response as List<dynamic>)
              .map<Content>((content) => Content.fromJson(content))
              .toList();
      return contents;
    } catch (e) {
      throw Exception('Failed to fetch contents: $e');
    }
  }

  void _refreshChapters() {
    setState(() {
      _chaptersFuture = _fetchChapters();
    });
  }

  void _addChapter() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm chương mới'),
            content: TextField(
              controller: _chapterTitleController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề chương',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  final title = _chapterTitleController.text.trim();
                  if (title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng nhập tiêu đề chương'),
                      ),
                    );
                    return;
                  }
                  try {
                    await ApiService.createChapter(title, widget.course.id);
                    _chapterTitleController.clear();
                    Navigator.pop(context);
                    _refreshChapters();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã thêm chương thành công'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi thêm chương: $e')),
                    );
                  }
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  void _addContent(String chapterId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Thêm nội dung mới'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề nội dung',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contentDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả nội dung',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  final title = _titleController.text.trim();
                  final description = _contentDescriptionController.text.trim();
                  if (title.isEmpty || description.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Vui lòng nhập đầy đủ tiêu đề và mô tả nội dung',
                        ),
                      ),
                    );
                    return;
                  }
                  try {
                    await ApiService.createContent(
                      _titleController.text.trim(),
                      description,
                      chapterId,
                      widget.course.id,
                    );
                    _contentDescriptionController.clear();
                    Navigator.pop(context);
                    _refreshChapters();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã thêm nội dung thành công'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi thêm nội dung: $e')),
                    );
                  }
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.course.name,
          style: const TextStyle(color: AppColors.primary),
        ),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      // ...existing code...
      body: FutureBuilder<List<Chapter>>(
        future: _chaptersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshChapters,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          final chapters = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Thông tin chi tiết course
              Card(
                color: AppColors.card,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.course.image.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.course.image,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        widget.course.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.course.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Giá: ${widget.course.price.toStringAsFixed(0)} VNĐ',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Số chương: ${chapters.length}',
                        style: const TextStyle(color: AppColors.subText),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Danh sách chapter
              if (chapters.isEmpty)
                const Center(child: Text('No chapters found.')),
              ...chapters.map(
                (chapter) => Card(
                  elevation: 3,
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      chapter.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      FutureBuilder<List<Content>>(
                        future: _fetchContents(chapter.id),
                        builder: (context, contentSnapshot) {
                          if (contentSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (contentSnapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Lỗi: ${contentSnapshot.error}'),
                            );
                          }

                          final contents = contentSnapshot.data ?? [];
                          return Column(
                            children: [
                              if (contents.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('No contents found.'),
                                )
                              else
                                ...contents.map(
                                  (content) => ListTile(
                                    title: Text(content.title),
                                    subtitle: Text(content.description),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: ElevatedButton(
                                  onPressed: () => _addContent(chapter.id),
                                  child: const Text('Thêm nội dung'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addChapter,
        icon: const Icon(Icons.add),
        label: const Text('Thêm chương'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
    );
  }
}
