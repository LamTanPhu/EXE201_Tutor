import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/snackbar_helper.dart';
import 'package:tutor/common/widgets/custom_app_bar.dart';
import 'package:tutor/common/widgets/input_field.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/services/supabase_service.dart';

class CourseEditScreen extends StatefulWidget {
  final Course course;

  const CourseEditScreen({super.key, required this.course});

  @override
  State<CourseEditScreen> createState() => _CourseEditScreenState();
}

class _CourseEditScreenState extends State<CourseEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;

  bool _isLoading = false;
  String? _localImagePath;

  @override
  void initState() {
    super.initState();
    print('CourseEditScreen: Initial course data: ${widget.course.toJson()}');
    _nameController = TextEditingController(text: widget.course.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.course.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.course.price > 0 ? _formatCurrency(widget.course.price) : '',
    );
    _imageController = TextEditingController(text: widget.course.image ?? '');
    _localImagePath = null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  String _formatCurrency(double price) {
    final intValue =
        (price * 100).round(); // Convert to cents to avoid decimal issues
    return intValue.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _localImagePath = file.path;
      });
      try {
        final uploadedUrl = await SupabaseService.uploadImage(
          file,
          oldFilePath:
              _imageController.text.isNotEmpty ? _imageController.text : null,
        );

        if (uploadedUrl != null) {
          setState(() {
            _imageController.text = uploadedUrl;
            _localImagePath = null;
          });
          SnackbarHelper.showSuccess(context, "Tải ảnh thành công");
        } else {
          SnackbarHelper.showError(
            context,
            "Không nhận được URL ảnh từ Supabase",
          );
        }
      } catch (e) {
        SnackbarHelper.showError(context, "Lỗi tải ảnh: $e");
        print('Lỗi upload ảnh: $e');
      }
    } else {
      SnackbarHelper.showWarning(context, "Bạn chưa chọn ảnh nào");
    }
  }

  Future<void> _updateCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final priceWidget = InputFieldWidget(
        controller: _priceController,
        label: 'Giá khoá học',
        isCurrency: true,
      );
      final priceVND = priceWidget.getCurrencyValue()?.toDouble() ?? 0.0;

      final updatedCourse = Course(
        id: widget.course.id,
        name: _nameController.text.trim(),
        description:
            _descriptionController.text.trim().isNotEmpty
                ? _descriptionController.text.trim()
                : null,
        image:
            _imageController.text.trim().isNotEmpty
                ? _imageController.text.trim()
                : null,
        price: priceVND,
        isActive: widget.course.isActive,
        createdBy: widget.course.createdBy,
        createdAt: widget.course.createdAt,
      );
      print('Updating course: ${updatedCourse.toJson()}');

      await ApiService.updateCourse(
        updatedCourse.id,
        updatedCourse.name,
        updatedCourse.description,
        updatedCourse.image,
        updatedCourse.price,
      );
      Navigator.pop(context, updatedCourse);
      SnackbarHelper.showSuccess(context, "Cập nhật khoá học thành công");
    } catch (e) {
      SnackbarHelper.showError(context, 'Không thể cập nhật khoá học: $e');
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Chỉnh sửa khoá học',
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _updateCourse,
            child: Text(
              'Lưu',
              style: TextStyle(
                color: _isLoading ? AppColors.disabled : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Course Preview Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:
                                _localImagePath != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(_localImagePath!),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.school,
                                                  color: AppColors.white,
                                                  size: 24,
                                                ),
                                      ),
                                    )
                                    : _imageController.text.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        _imageController.text,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.school,
                                                  color: AppColors.white,
                                                  size: 24,
                                                ),
                                      ),
                                    )
                                    : const Icon(
                                      Icons.school,
                                      color: AppColors.white,
                                      size: 24,
                                    ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Đang chỉnh sửa',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _nameController.text.isNotEmpty
                                    ? _nameController.text
                                    : widget.course.name ??
                                        'Khoá học không tên',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Form Fields
              InputFieldWidget(
                controller: _nameController,
                label: 'Tên khoá học',
                prefixIcon: Icons.book,
                validator:
                    (value) =>
                        InputValidators.minLength(value, 3, 'tên khoá học'),
              ),
              InputFieldWidget(
                controller: _descriptionController,
                label: 'Mô tả khoá học',
                prefixIcon: Icons.description,
                maxLines: 4,
                validator:
                    (value) =>
                        InputValidators.maxLength(value, 500, 'mô tả khoá học'),
              ),
              InputFieldWidget(
                controller: _priceController,
                label: 'Giá khoá học',
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                isCurrency: true,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hình ảnh khoá học',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InputFieldWidget(
                          controller: _imageController,
                          label: 'URL hình ảnh',
                          prefixIcon: Icons.link,
                          enabled: false,
                          validator: InputValidators.url,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _pickImage,
                        icon: const Icon(
                          Icons.upload,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Update Button
              Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: _isLoading ? null : AppColors.primaryGradient,
                  color: _isLoading ? AppColors.disabled : null,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow:
                      _isLoading
                          ? null
                          : [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                            ),
                          ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            ),
                          )
                          : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_rounded, color: AppColors.white),
                              SizedBox(width: 8),
                              Text(
                                'Cập nhật khoá học',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed:
                    _isLoading
                        ? null
                        : () {
                          Navigator.pop(context);
                        },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Huỷ bỏ',
                  style: TextStyle(
                    color:
                        _isLoading ? AppColors.disabled : AppColors.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
