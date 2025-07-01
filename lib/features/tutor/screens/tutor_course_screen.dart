// features/tutor/tutor_courses_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/models/course_item.dart';
import 'package:tutor/features/tutor/screens/course_creation_screen.dart';

class TutorCoursesScreen extends StatefulWidget {
  const TutorCoursesScreen({super.key});

  @override
  State<TutorCoursesScreen> createState() => _TutorCoursesScreenState();
}

class _TutorCoursesScreenState extends State<TutorCoursesScreen> {
  late Future<List<CourseItem>> _coursesFuture;

  @override
  void initState() {
    super.initState();
  }

  void _showCourseDetails(BuildContext context, CourseItem courseItem) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(courseItem.course.name ?? 'Chưa đặt tên'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (courseItem.course.image != null &&
                      courseItem.course.image!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: courseItem.course.image!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    'Mô tả: ${courseItem.course.description ?? 'Không có'}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Giá: ${courseItem.course.price?.toStringAsFixed(0) ?? '0'} VNĐ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kích hoạt: ${courseItem.course.isActive == true ? 'Có' : 'Không'}',
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ngày tạo: ${courseItem.course.createdAt?.toString().substring(0, 16) ?? 'Không rõ'}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khoá học của tôi'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCourseScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Tạo khoá học mới',
      ),
      body: FutureBuilder<List<CourseItem>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final courses = snapshot.data!;
            return ListView.separated(
              itemCount: courses.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final courseItem = courses[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    courseItem.course.name ?? 'Chưa đặt tên',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(courseItem.course.description ?? 'Không có mô tả'),
                      Text(
                        'Giá: ${courseItem.course.price?.toStringAsFixed(0) ?? '0'} VNĐ',
                      ),
                    ],
                  ),
                  leading:
                      courseItem.course.image != null &&
                              courseItem.course.image!.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(
                              imageUrl: courseItem.course.image!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) =>
                                      const Icon(Icons.image),
                            ),
                          )
                          : const Icon(Icons.image, size: 50),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showCourseDetails(context, courseItem),
                    tooltip: 'Xem chi tiết',
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Không có khoá học nào'));
        },
      ),
    );
  }
}
