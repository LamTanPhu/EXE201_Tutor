import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor/common/models/chapter.dart';
import 'package:tutor/common/models/content.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/date_format.dart';
import 'package:tutor/common/utils/currency.dart';
import 'package:tutor/common/widgets/custom_app_bar.dart';
import 'package:tutor/common/widgets/input_field.dart';
import 'package:tutor/services/api_service.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> 
    with TickerProviderStateMixin {
  late Future<List<Chapter>> _chaptersFuture;
  final _chapterTitleController = TextEditingController();
  final _contentDescriptionController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _chaptersFuture = _fetchChapters();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _chapterTitleController.dispose();
    _contentDescriptionController.dispose();
    _animationController.dispose();
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
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.library_books_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Thêm chương mới',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputFieldWidget(
              controller: _chapterTitleController,
              label: 'Tiêu đề chương',
              hint: 'Nhập tiêu đề cho chương mới',
              prefixIcon: Icons.title,
              //validator: InputValidators.minLength(_chapterTitleController.text, 3, 'tiêu đề chương'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Huỷ',
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => _addChapter(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Thêm chương'),
          ),
        ],
      ),
    );
  }

  Future<void> _addChapter() async {
    final title = _chapterTitleController.text.trim();
    if (title.isEmpty || title.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tiêu đề chương phải có ít nhất 3 ký tự'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
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
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.white),
              const SizedBox(width: 8),
              const Text('Đã thêm chương thành công'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi thêm chương: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAddContentDialog(String chapterId) {
    _contentDescriptionController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.article_rounded,
                color: AppColors.info,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Thêm nội dung mới',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputFieldWidget(
              controller: _contentDescriptionController,
              label: 'Mô tả nội dung',
              hint: 'Nhập mô tả cho nội dung mới',
              maxLines: 4,
              prefixIcon: Icons.description,
              //validator: InputValidators.required(_contentDescriptionController.text, 'mô tả nội dung'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Huỷ',
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => _addContent(chapterId),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.info,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Thêm nội dung'),
          ),
        ],
      ),
    );
  }

  Future<void> _addContent(String chapterId) async {
    final description = _contentDescriptionController.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng nhập mô tả nội dung'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final accountId = prefs.getString('accountId') ?? '';
      
      if (accountId.isEmpty) {
        throw Exception('Không tìm thấy tài khoản');
      }
      
      await ApiService.createContent(chapterId, description, accountId);
      _contentDescriptionController.clear();
      Navigator.pop(context);
      _refreshChapters();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.white),
              const SizedBox(width: 8),
              const Text('Đã thêm nội dung thành công'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi thêm nội dung: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildCourseInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            if (widget.course.image?.isNotEmpty == true)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.course.image!),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) => const Icon(
                      Icons.school,
                      color: AppColors.white,
                      size: 48,
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.primary.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: const Center(
                  child: Icon(
                    Icons.school,
                    color: AppColors.white,
                    size: 48,
                  ),
                ),
              ),
            
            // Course Info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.course.name ?? 'Không có tên',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      if (widget.course.isActive != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.course.isActive!
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.course.isActive! ? 'Hoạt động' : 'Không hoạt động',
                            style: TextStyle(
                              color: widget.course.isActive! ? AppColors.success : AppColors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  if (widget.course.description?.isNotEmpty == true) ...[
                    Text(
                      widget.course.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Creator and Creation Date
                  // if (widget.course.createdBy != null || widget.course.createdAt != null)
                  //   Text(
                  //     [
                  //       if (widget.course.createdBy != null) 'Tạo bởi: ${widget.course.createdBy}',
                  //       if (widget.course.createdAt != null)
                  //         'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(widget.course.createdAt!)}',
                  //     ].join(' • '),
                  //     style: TextStyle(
                  //       color: AppColors.white.withOpacity(0.8),
                  //       fontSize: 12,
                  //     ),
                  //   ),
                  // if (widget.course.createdBy != null || widget.course.createdAt != null)
                  //   const SizedBox(height: 16),
                  
                  // Stats Row
                  Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    children: [
                      _buildStatItem(
                        icon: Icons.attach_money,
                        label: 'Giá',
                        value: CurrencyUtils.formatVND(widget.course.price),
                      ),
                      FutureBuilder<List<Chapter>>(
                        future: _chaptersFuture,
                        builder: (context, snapshot) {
                          final chapterCount = snapshot.data?.length ?? 0;
                          return _buildStatItem(
                            icon: Icons.menu_book,
                            label: 'Chương',
                            value: '$chapterCount chương',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyChapters() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chưa có chương nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy thêm chương đầu tiên cho khoá học của bạn',
              style: TextStyle(
                color: AppColors.subText,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterCard(Chapter chapter, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
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
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  childrenPadding: const EdgeInsets.only(bottom: 16),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  title: Text(
                    chapter.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.text,
                    ),
                  ),
                  children: [
                    FutureBuilder<List<Content>>(
                      future: _fetchContents(chapter.id),
                      builder: (context, contentSnapshot) {
                        if (contentSnapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          );
                        }
                        
                        if (contentSnapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Lỗi: ${contentSnapshot.error}',
                                  style: const TextStyle(color: AppColors.error),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                        
                        final contents = contentSnapshot.data ?? [];
                        return Column(
                          children: [
                            if (contents.isEmpty)
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.divider.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: AppColors.info.withOpacity(0.7),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Chưa có nội dung nào',
                                      style: TextStyle(
                                        color: AppColors.subText,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ...contents.asMap().entries.map((entry) {
                                final contentIndex = entry.key;
                                final content = entry.value;
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.1),
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    leading: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppColors.info.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${contentIndex + 1}',
                                          style: const TextStyle(
                                            color: AppColors.info,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      content.contentDescription,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    // subtitle: content.updatedAt != null
                                    //     ? Text(
                                    //         'Cập nhật: ${DateFormat.formatDate(content.updatedAt)}',
                                    //         style: const TextStyle(
                                    //           color: AppColors.subText,
                                    //           fontSize: 12,
                                    //         ),
                                    //       )
                                    //     : null,
                                  ),
                                );
                              }),
                            
                            // Add Content Button
                            Container(
                              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _showAddContentDialog(chapter.id),
                                icon: const Icon(Icons.add_rounded, size: 20),
                                label: const Text(
                                  'Thêm nội dung',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.info,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
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
        title: widget.course.name ?? 'Không có tên',
        actions: [
          IconButton(
            onPressed: _refreshChapters,
            icon: const Icon(Icons.refresh_rounded),
            color: AppColors.primary,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: FutureBuilder<List<Chapter>>(
            future: _chaptersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    _buildCourseInfoCard(),
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                );
              }
              
              if (snapshot.hasError) {
                return Column(
                  children: [
                    _buildCourseInfoCard(),
                    Expanded(
                      child: Center(
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
                            const Text(
                              'Có lỗi xảy ra',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Lỗi: ${snapshot.error}',
                              style: const TextStyle(
                                color: AppColors.subText,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _refreshChapters,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Thử lại'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              
              final chapters = snapshot.data ?? [];
              
              return CustomScrollView(
                slivers: [
                  // Course Info Card
                  SliverToBoxAdapter(
                    child: _buildCourseInfoCard(),
                  ),
                  
                  // Chapters Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.list_alt_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Danh sách chương (${chapters.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Chapters List
                  if (chapters.isEmpty)
                    SliverToBoxAdapter(
                      child: _buildEmptyChapters(),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildChapterCard(chapters[index], index),
                        childCount: chapters.length,
                      ),
                    ),
                  
                  // Bottom spacing
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              offset: const Offset(0, 8),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _showAddChapterDialog,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Thêm chương',
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