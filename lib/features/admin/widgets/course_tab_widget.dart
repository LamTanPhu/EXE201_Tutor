import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/currency.dart';

class CoursesTabWidget extends StatelessWidget {
  final List<Course> courses;

  const CoursesTabWidget({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: AppColors.subText),
            SizedBox(height: 16),
            Text(
              "Không có khóa học nào",
              style: TextStyle(color: AppColors.text, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return _buildCourseCard(course, context);
      },
    );
  }

  Widget _buildCourseCard(Course course, BuildContext context) {
    return Card(
      color: AppColors.card,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: AppColors.primary.withOpacity(0.1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.card,
              AppColors.backgroundGradientStart.withOpacity(0.2),
            ],
          ),
        ),
        child: InkWell(
          onTap: () {
            _showCourseDetails(course, context);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header với hình ảnh và thông tin cơ bản
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh khóa học
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: course.image?.isNotEmpty == true
                            ? CachedNetworkImage(
                                imageUrl: course.image!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.background,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.background,
                                  child: const Icon(
                                    Icons.image,
                                    color: AppColors.subText,
                                    size: 32,
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.background,
                                child: const Icon(
                                  Icons.school,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Thông tin khóa học
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.name ?? 'Không có tên',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          
                          // Giá và trạng thái
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8, 
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  CurrencyUtils.formatVND(course.price),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (course.isActive != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8, 
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: course.isActive!
                                        ? Colors.green.withOpacity(0.1)
                                        : AppColors.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    course.isActive! ? 'Hoạt động' : 'Không hoạt động',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: course.isActive!
                                          ? Colors.green[700]
                                          : AppColors.error,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Mô tả khóa học
                Text(
                  course.description?.isNotEmpty == true
                      ? course.description!
                      : 'Không có mô tả',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.subText,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // Thông tin thêm
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    if (course.createdBy != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            size: 14,
                            color: AppColors.subText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tạo bởi: ${course.createdBy}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.subText,
                            ),
                          ),
                        ],
                      ),
                    if (course.createdAt != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppColors.subText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tạo ngày: ${_formatDate(course.createdAt!)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.subText,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCourseDetails(Course course, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.backgroundGradientStart, 
                AppColors.backgroundGradientEnd
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: course.image?.isNotEmpty == true
                            ? CachedNetworkImage(
                                imageUrl: course.image!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.background,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.background,
                                  child: const Icon(
                                    Icons.image,
                                    color: AppColors.subText,
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.background,
                                child: const Icon(
                                  Icons.school,
                                  color: AppColors.primary,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.name ?? 'Không có tên',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (course.isActive != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8, 
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: course.isActive!
                                    ? Colors.green.withOpacity(0.1)
                                    : AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                course.isActive! ? 'Hoạt động' : 'Không hoạt động',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: course.isActive!
                                      ? Colors.green[700]
                                      : AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Chi tiết
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRowDialog('Mô tả', course.description?.isNotEmpty == true ? course.description! : 'Không có mô tả'),
                        _buildDetailRowDialog('Giá', CurrencyUtils.formatVND(course.price)),
                        if (course.createdBy != null)
                          _buildDetailRowDialog('Tạo bởi', course.createdBy!),
                        if (course.createdAt != null)
                          _buildDetailRowDialog('Ngày tạo', _formatDate(course.createdAt!)),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Nút đóng
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Đóng'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Widget _buildDetailRowDialog(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.subText,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.text,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}