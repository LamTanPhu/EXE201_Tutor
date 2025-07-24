import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/models/course_item.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/currency.dart';

class CourseDetailsDialog extends StatelessWidget {
  final CourseItem courseItem;

  const CourseDetailsDialog({super.key, required this.courseItem});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header với hình ảnh và tiêu đề
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: courseItem.course.image != null && courseItem.course.image!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: courseItem.course.image!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppColors.background,
                                child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.background,
                                child: const Icon(Icons.error, color: AppColors.subText),
                              ),
                            )
                          : Container(
                              color: AppColors.background,
                              child: const Icon(Icons.image, color: AppColors.subText, size: 40),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courseItem.course.name ?? 'Khóa học chưa có tên',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: courseItem.course.isActive == true
                                ? Colors.green.withOpacity(0.1)
                                : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            courseItem.course.isActive == true ? 'Hoạt động' : 'Không hoạt động',
                            style: TextStyle(
                              color: courseItem.course.isActive == true
                                  ? Colors.green[700]
                                  : AppColors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Chi tiết khóa học
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Mô tả', courseItem.course.description ?? 'Chưa có mô tả'),
                      _buildDetailRow('Giá', CurrencyUtils.formatVND(courseItem.course.price)),
                      _buildDetailRow('Tạo bởi', courseItem.account.fullName ?? 'Không rõ'),
                      _buildDetailRow('Email', courseItem.account.email ?? 'Chưa có email'),
                      _buildDetailRow(
                          'Ngày tạo', courseItem.course.createdAt?.toString().split('.')[0] ?? 'Chưa có thông tin'),
                      const SizedBox(height: 16),
                      const Text(
                        'Chứng chỉ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.text),
                      ),
                      const SizedBox(height: 8),
                      if (courseItem.certifications.isNotEmpty)
                        ...courseItem.certifications.map(
                          (cert) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.verified, size: 16, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${cert.name ?? 'Chưa có tên'} (${cert.description ?? 'Chưa có mô tả'})',
                                    style: const TextStyle(color: AppColors.text),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const Text(
                          'Không có chứng chỉ',
                          style: TextStyle(color: AppColors.subText),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Nút hành động
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đóng', style: TextStyle(color: AppColors.subText)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.subText),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400, color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}