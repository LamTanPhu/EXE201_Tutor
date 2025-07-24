import 'package:flutter/material.dart';
import 'package:tutor/common/models/course_item.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/widgets/custom_loading.dart';
import 'package:tutor/features/admin/widgets/course_card.dart';
import 'package:tutor/features/admin/widgets/course_detail_dialog.dart';
import 'package:tutor/services/api_service.dart';

class GetAllCoursesScreen extends StatefulWidget {
  const GetAllCoursesScreen({super.key});

  @override
  State<GetAllCoursesScreen> createState() => _GetAllCoursesScreenState();
}

class _GetAllCoursesScreenState extends State<GetAllCoursesScreen> {
  late Future<List<CourseItem>> _coursesFuture;
  String _searchQuery = '';
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _coursesFuture = ApiService.getAllCourses();
  }

  void _refreshCourses() {
    setState(() {
      _coursesFuture = ApiService.getAllCourses();
    });
  }

  List<CourseItem> _filterCourses(List<CourseItem> courses) {
    if (_searchQuery.isEmpty) return courses;
    return courses.where((courseItem) {
      final courseName = courseItem.course.name?.toLowerCase() ?? '';
      final authorName = courseItem.account.fullName?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return courseName.contains(query) || authorName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Tất cả khóa học',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.lightPrimary],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.list : Icons.grid_view,
              color: AppColors.white,
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'Chế độ danh sách' : 'Chế độ lưới',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: _refreshCourses,
            tooltip: 'Làm mới',
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.lightPrimary],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: AppColors.text),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm khóa học...',
                hintStyle: const TextStyle(color: AppColors.subText),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(color: AppColors.accent, width: 2),
                ),
              ),
            ),
          ),
          // Danh sách/lưới khóa học
          Expanded(
            child: FutureBuilder<List<CourseItem>>(
              future: _coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomLoading();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Lỗi: ${snapshot.error}',
                          style: const TextStyle(color: AppColors.text),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshCourses,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                          ),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: AppColors.subText,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Không có khóa học nào',
                          style: TextStyle(color: AppColors.text),
                        ),
                      ],
                    ),
                  );
                }

                final filteredCourses = _filterCourses(snapshot.data!);
                if (_isGridView) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      return CourseCardWidget(
                        courseItem: filteredCourses[index],
                        onViewDetails:
                            () => _showCourseDetails(
                              context,
                              filteredCourses[index],
                            ),
                        //onEdit: () => _showUpdateCourseDialog(context, filteredCourses[index]),
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      return CourseCardWidget(
                        courseItem: filteredCourses[index],
                        onViewDetails:
                            () => _showCourseDetails(
                              context,
                              filteredCourses[index],
                            ),
                        //onEdit: () => _showUpdateCourseDialog(context, filteredCourses[index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCourseDetails(BuildContext context, CourseItem courseItem) {
    showDialog(
      context: context,
      builder: (context) => CourseDetailsDialog(courseItem: courseItem),
    );
  }

  // void _showUpdateCourseDialog(BuildContext context, CourseItem courseItem) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => UpdateCourseDialog(
  //       courseItem: courseItem,
  //       onUpdateSuccess: _refreshCourses,
  //     ),
  //   );
  // }
}
