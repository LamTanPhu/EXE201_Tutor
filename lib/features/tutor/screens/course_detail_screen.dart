import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor/common/models/chapter.dart';
import 'package:tutor/common/models/content.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/date_format.dart';
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

  @override
  void initState() {
    super.initState();
    _chaptersFuture = _fetchChapters();
  }

  @override
  void dispose() {
    _chapterTitleController.dispose();
    _contentDescriptionController.dispose();
    super.dispose();
  }

  Future<List<Chapter>> _fetchChapters() async {
    try {
      if (widget.course.id.isEmpty) {
        throw Exception('Course ID is empty');
      }
      final response = await ApiService.getCourseChapters(widget.course.id);
      return response.map<Chapter>((chapter) => Chapter.fromJson(chapter)).toList();
    } catch (e) {
      throw Exception('Failed to fetch chapters: $e');
    }
  }

  Future<List<Content>> _fetchContents(String chapterId) async {
    try {
      if (chapterId.isEmpty) {
        throw Exception('Chapter ID is empty');
      }
      final response = await ApiService.getChapterContent(chapterId);
      return response.map<Content>((content) => Content.fromJson(content)).toList();
    } catch (e) {
      throw Exception('Failed to fetch contents: $e');
    }
  }

  void _refreshChapters() {
    setState(() {
      _chaptersFuture = _fetchChapters();
    });
  }

  void _showAddChapterDialog() {
    _chapterTitleController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                  const SnackBar(content: Text('Vui lòng nhập tiêu đề chương')),
                );
                return;
              }
              try {
                await ApiService.createChapter(title, widget.course.id);
                _chapterTitleController.clear();
                Navigator.pop(context);
                _refreshChapters();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã thêm chương thành công')),
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

  void _showAddContentDialog(String chapterId) async {
    _contentDescriptionController.clear();
    final prefs = await SharedPreferences.getInstance();
    final accountId = prefs.getString('accountId') ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm nội dung mới'),
        content: TextField(
          controller: _contentDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Mô tả nội dung',
            border: OutlineInputBorder(),
          ),
          minLines: 2,
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              final description = _contentDescriptionController.text.trim();
              if (description.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập mô tả nội dung')),
                );
                return;
              }
              if (accountId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không tìm thấy tài khoản')),
                );
                return;
              }
              try {
                await ApiService.createContent(
                  chapterId,
                  description,
                  accountId,
                );
                _contentDescriptionController.clear();
                Navigator.pop(context);
                _refreshChapters();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã thêm nội dung thành công')),
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
                          if (contentSnapshot.connectionState == ConnectionState.waiting) {
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
                                  child: Text('Không tìm thấy nội dung.'),
                                )
                              else
                                ...contents.map(
                                  (content) => Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.article, color: AppColors.primary),
                                      title: Text(
                                        content.contentDescription,
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        content.updatedAt != null
                                            ? 'Cập nhật: ${DateFormat.formatDate(content.updatedAt)}'
                                            : 'Chưa cập nhật',
                                        style: const TextStyle(
                                          color: AppColors.subText,
                                          fontSize: 13,
                                        ),
                                      ),
                                      tileColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: ElevatedButton.icon(
                                  onPressed: () => _showAddContentDialog(chapter.id),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Thêm nội dung'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
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
        onPressed: _showAddChapterDialog,
        icon: const Icon(Icons.add),
        label: const Text('Thêm chương'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
    );
  }
}