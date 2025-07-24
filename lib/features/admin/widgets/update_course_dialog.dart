import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor/common/models/course_item.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/services/supabase_service.dart';

class UpdateCourseDialog extends StatefulWidget {
  final CourseItem courseItem;
  final VoidCallback onUpdateSuccess;

  const UpdateCourseDialog({
    super.key,
    required this.courseItem,
    required this.onUpdateSuccess,
  });

  @override
  State<UpdateCourseDialog> createState() => _UpdateCourseDialogState();
}

class _UpdateCourseDialogState extends State<UpdateCourseDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  bool isActive = false;
  File? selectedImage;
  String? currentImageUrl;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.courseItem.course.name ?? '';
    descriptionController.text = widget.courseItem.course.description ?? '';
    priceController.text = widget.courseItem.course.price?.toString() ?? '';
    isActive = widget.courseItem.course.isActive ?? false;
    currentImageUrl = widget.courseItem.course.image;
  }

  Future<void> _updateCourse() async {
    try {
      // Hiển thị loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
      );

      String? imageUrl = currentImageUrl;
      if (selectedImage != null) {
        // Upload ảnh mới và xóa ảnh cũ nếu có
        imageUrl = await SupabaseService.uploadImage(
          selectedImage!,
          oldFilePath: currentImageUrl,
        );
      }

      //cập nhật course
      await ApiService.updateCourse(
        widget.courseItem.course.id,
        nameController.text,
        descriptionController.text,
        imageUrl,
        double.tryParse(priceController.text),
      );

      Navigator.pop(context); // Đóng dialog loading
      Navigator.pop(context); // Đóng dialog cập nhật
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật khóa học thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      widget.onUpdateSuccess();
    } catch (e) {
      Navigator.pop(context); // Đóng dialog loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi cập nhật khóa học: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
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
              const Text(
                'Cập nhật khóa học',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Phần hình ảnh
                      const Text(
                        'Hình ảnh khóa học',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              setState(() {
                                selectedImage = File(image.path);
                              });
                            }
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.lightPrimary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:
                                selectedImage != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : currentImageUrl != null &&
                                        currentImageUrl!.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: currentImageUrl!,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => const Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) => const Icon(
                                              Icons.add_photo_alternate,
                                              size: 40,
                                              color: AppColors.accent,
                                            ),
                                      ),
                                    )
                                    : const Icon(
                                      Icons.add_photo_alternate,
                                      size: 40,
                                      color: AppColors.accent,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Các trường form
                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: AppColors.text),
                        decoration: InputDecoration(
                          labelText: 'Tên khóa học',
                          labelStyle: const TextStyle(color: AppColors.subText),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.lightPrimary,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        style: const TextStyle(color: AppColors.text),
                        decoration: InputDecoration(
                          labelText: 'Mô tả',
                          labelStyle: const TextStyle(color: AppColors.subText),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.lightPrimary,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppColors.text),
                        decoration: InputDecoration(
                          labelText: 'Giá (VNĐ)',
                          labelStyle: const TextStyle(color: AppColors.subText),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.lightPrimary,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Switch(
                            value: isActive,
                            onChanged: (value) {
                              setState(() {
                                isActive = value;
                              });
                            },
                            activeColor: AppColors.primary,
                            activeTrackColor: AppColors.lightPrimary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Khóa học hoạt động',
                            style: TextStyle(color: AppColors.text),
                          ),
                        ],
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
                    child: const Text(
                      'Hủy',
                      style: TextStyle(color: AppColors.subText),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _updateCourse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 2,
                    ),
                    child: const Text('Cập nhật'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
