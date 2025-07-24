import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/models/course_item.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/currency.dart';

class CourseCardWidget extends StatelessWidget {
  final CourseItem courseItem;
  final VoidCallback onViewDetails;

  const CourseCardWidget({
    super.key,
    required this.courseItem,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.card,
      child: InkWell(
        onTap: onViewDetails,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Hình ảnh khóa học
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      courseItem.course.image != null &&
                              courseItem.course.image!.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: courseItem.course.image!,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  color: AppColors.background,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) => Container(
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
                              Icons.image,
                              color: AppColors.subText,
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
                      courseItem.course.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bởi ${courseItem.account.fullName ?? 'Không rõ'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.subText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          CurrencyUtils.formatVND(courseItem.course.price),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                courseItem.course.isActive == true
                                    ? Colors.green.withOpacity(0.1)
                                    : AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            courseItem.course.isActive == true
                                ? 'Hoạt động'
                                : 'Không hoạt động',
                            style: TextStyle(
                              color:
                                  courseItem.course.isActive == true
                                      ? Colors.green[700]
                                      : AppColors.error,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Nút hành động
              IconButton(
                onPressed: onViewDetails,
                icon: const Icon(Icons.visibility, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
