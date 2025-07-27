import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/currency.dart';
import 'package:tutor/common/utils/shared_prefs.dart';
import 'package:tutor/common/utils/snackbar_helper.dart';
import 'package:tutor/common/widgets/custom_app_bar.dart';
import 'package:tutor/common/widgets/custom_search_bar.dart';
import 'package:tutor/features/tutor/screens/course_creation_screen.dart';
import 'package:tutor/features/tutor/screens/course_detail_screen.dart';
import 'package:tutor/features/tutor/screens/edit_course_screen.dart';
import 'package:tutor/services/api_service.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen>
    with TickerProviderStateMixin {
  late Future<List<Course>> _coursesFuture;
  String _searchText = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchCourses();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<Course>> _fetchCourses() async {
    try {
      final accountId = await SharedPrefs.getAccountId();
      if (accountId == null) {
        Future.delayed(Duration.zero, () {
          SnackbarHelper.showError(
            context,
            'Không tìm thấy thông tin tài khoản. Vui lòng đăng nhập lại.',
          );
        });
        return [];
      }
      final accountDetail = await ApiService.getCourseByAccount(accountId);
      return accountDetail.courses;
    } catch (e) {
      Future.delayed(Duration.zero, () {
        SnackbarHelper.showError(
          context,
          'Không thể tải danh sách khoá học: $e',
        );
      });
      return [];
    }
  }

  void _refreshCourses() {
    setState(() {
      _coursesFuture = _fetchCourses();
    });
  }

  void _goToCourseCreation() async {
    final newCourse = await Navigator.push<Course>(
      context,
      MaterialPageRoute(builder: (_) => const CreateCourseScreen()),
    );
    if (newCourse != null) {
      _refreshCourses();
      SnackbarHelper.showSuccess(context, 'Khoá học đã được tạo thành công!');
    }
  }

  void _goToCourseEdit(Course course) async {
    final updatedCourse = await Navigator.push<Course>(
      context,
      MaterialPageRoute(builder: (_) => CourseEditScreen(course: course)),
    );
    if (updatedCourse != null) {
      _refreshCourses();
      SnackbarHelper.showSuccess(
        context,
        'Khoá học đã được cập nhật thành công!',
      );
    }
  }

  List<Course> _filteredCourses(List<Course> courses) {
    if (_searchText.isEmpty) return courses;
    return courses.where((c) {
      final name = c.name?.toLowerCase() ?? '';
      final description = c.description?.toLowerCase() ?? '';
      final createdBy = c.createdBy?.toLowerCase() ?? '';
      return name.contains(_searchText.toLowerCase()) ||
          description.contains(_searchText.toLowerCase()) ||
          createdBy.contains(_searchText.toLowerCase());
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Chưa có khoá học nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchText.isEmpty
                ? 'Hãy tạo khoá học đầu tiên của bạn!'
                : 'Không tìm thấy khoá học phù hợp',
            style: const TextStyle(color: AppColors.subText, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          if (_searchText.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _goToCourseCreation,
              icon: const Icon(Icons.add),
              label: const Text('Tạo khoá học'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.white, AppColors.white.withOpacity(0.95)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailScreen(course: course),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Course Image
                        Container(
                          width: 100,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient:
                                course.image?.isNotEmpty == true
                                    ? null
                                    : AppColors.primaryGradient,
                          ),
                          child:
                              course.image?.isNotEmpty == true
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      course.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  gradient:
                                                      AppColors.primaryGradient,
                                                ),
                                                child: const Icon(
                                                  Icons.school,
                                                  color: AppColors.white,
                                                  size: 32,
                                                ),
                                              ),
                                    ),
                                  )
                                  : const Icon(
                                    Icons.school,
                                    color: AppColors.white,
                                    size: 32,
                                  ),
                        ),
                        const SizedBox(width: 16),
                        // Course Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      course.name ?? 'Không có tên',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.text,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (course.isActive != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            course.isActive!
                                                ? AppColors.success.withOpacity(
                                                  0.1,
                                                )
                                                : AppColors.error.withOpacity(
                                                  0.1,
                                                ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        course.isActive!
                                            ? 'Hoạt động'
                                            : 'Không hoạt động',
                                        style: TextStyle(
                                          color:
                                              course.isActive!
                                                  ? AppColors.success
                                                  : AppColors.error,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                course.description?.isNotEmpty == true
                                    ? course.description!
                                    : 'Không có mô tả',
                                style: const TextStyle(
                                  color: AppColors.subText,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              if (course.createdBy != null ||
                                  course.createdAt != null)
                                Text(
                                  [
                                    if (course.createdBy != null)
                                      'Tạo bởi: ${course.createdBy}',
                                    if (course.createdAt != null)
                                      'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(course.createdAt!)}',
                                  ].join(' • '),
                                  style: const TextStyle(
                                    color: AppColors.subText,
                                    fontSize: 12,
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      CurrencyUtils.formatVND(course.price),
                                      style: const TextStyle(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed:
                                            () => _goToCourseEdit(course),
                                        icon: const Icon(Icons.edit_outlined),
                                        color: AppColors.info,
                                        iconSize: 20,
                                        constraints: const BoxConstraints(
                                          minWidth: 32,
                                          minHeight: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Các khoá học của tôi',
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _refreshCourses,
            icon: const Icon(Icons.refresh_rounded),
            color: AppColors.primary,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomSearchBar(
              hintText: 'Tìm kiếm khoá học, người tạo...',
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              onClear: () {
                setState(() {
                  _searchText = '';
                });
              },
            ),
          ),
          // Course List
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: FutureBuilder<List<Course>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Có lỗi xảy ra',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Lỗi: ${snapshot.error}',
                            style: const TextStyle(color: AppColors.subText),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _refreshCourses,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Thử lại'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final courses = snapshot.data ?? [];
                  final filteredCourses = _filteredCourses(courses);

                  if (filteredCourses.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      return _buildCourseCard(course, index);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _goToCourseCreation,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Thêm khoá học',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
      ),
    );
  }
}
