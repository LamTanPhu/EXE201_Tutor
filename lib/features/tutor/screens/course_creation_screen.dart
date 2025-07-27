import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/snackbar_helper.dart';
import 'package:tutor/common/widgets/custom_app_bar.dart';
import 'package:tutor/common/widgets/input_field.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/services/supabase_service.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedImage;
  bool _isLoading = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
    _priceController.addListener(_validateForm);
    _validateForm();
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateForm);
    _descriptionController.removeListener(_validateForm);
    _priceController.removeListener(_validateForm);
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (mounted && !_isLoading) {
      setState(() {
        // No _isFormValid field; rely on getter
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      setState(() {
        _isLoading = true;
      });
      try {
        final file = File(pickedFile.path);
        final uploadedUrl = await SupabaseService.uploadImage(file);
        if (uploadedUrl != null && mounted) {
          setState(() {
            _selectedImage = uploadedUrl;
            _isLoading = false;
          });
          SnackbarHelper.showSuccess(context, "Tải ảnh thành công");
          _validateForm();
        } else {
          throw Exception('Không nhận được URL hình ảnh');
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          print('Image upload error: $e');
          SnackbarHelper.showError(context, "Lỗi tải ảnh: $e");
        }
      }
    } else if (mounted) {
      SnackbarHelper.showWarning(context, "Bạn chưa chọn ảnh nào");
    }
  }

  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate() || _selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      final priceInput = InputFieldWidget(
        controller: _priceController,
        label: 'Giá khóa học',
        isCurrency: true,
      );
      final price = priceInput.getCurrencyValue()?.toDouble() ?? 0.0;
      print('Creating course: name=$name, price=$price, image=$_selectedImage');

      final apiCourse = await ApiService.createCourse(
        name: name,
        description: description,
        image: _selectedImage!,
        price: price,
      );

      if (mounted) {
        final course = Course(
          id: apiCourse.id,
          name: name,
          description: description.isNotEmpty ? description : null,
          image: _selectedImage,
          price: price,
          isActive: _isActive,
        );
        SnackbarHelper.showSuccess(context, "Tạo khóa học thành công");
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) Navigator.pop(context, course);
        });
      }
    } catch (e, stackTrace) {
      if (mounted) {
        print('Create course error: $e\nStack trace: $stackTrace');
        SnackbarHelper.showError(context, "Lỗi tạo khóa học: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatCurrency(double price) {
    final numberFormat = NumberFormat('#,###', 'vi_VN');
    return numberFormat.format(price.round());
  }

  bool get _isFormValid => _formKey.currentState?.validate() == true && _selectedImage != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Tạo khóa học',
        actions: [
          TextButton(
            onPressed: _isLoading || !_isFormValid ? null : _createCourse,
            child: Text(
              'Lưu',
              style: TextStyle(
                color: _isLoading || !_isFormValid ? AppColors.disabled : AppColors.primary,
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
              // Preview Card
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
                          onTap: _isLoading ? null : _pickImage,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, _) {
                                        print('Image preview error: $error');
                                        return const Icon(
                                          Icons.school,
                                          color: AppColors.white,
                                          size: 24,
                                        );
                                      },
                                    ),
                                  )
                                : const Icon(
                                    Icons.image,
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
                                'Đang tạo',
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
                                    : 'Khóa học chưa có tên',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (_priceController.text.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Giá: ${_formatCurrency(double.tryParse(_priceController.text.replaceAll(',', '')) ?? 0.0)} VNĐ',
                                  style: TextStyle(
                                    color: AppColors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
                label: 'Tên khóa học',
                prefixIcon: Icons.book,
                validator: (value) => InputValidators.required(value, 'tên khóa học'),
              ),
              InputFieldWidget(
                controller: _descriptionController,
                label: 'Mô tả',
                prefixIcon: Icons.description,
                maxLines: 4,
                validator: (value) => InputValidators.maxLength(value, 500, 'mô tả'),
              ),
              InputFieldWidget(
                controller: _priceController,
                label: 'Giá khóa học',
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                isCurrency: true,
              ),
              const SizedBox(height: 16),
              // Image Upload
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hình ảnh khóa học *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _isLoading ? null : _pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, _) {
                                  print('Image preview error: $error');
                                  return const Center(
                                    child: Icon(
                                      Icons.error_outline,
                                      color: AppColors.error,
                                      size: 24,
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upload_rounded,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tải lên hình ảnh',
                                    style: TextStyle(
                                      color: AppColors.subText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Create Button
              Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: _isLoading || !_isFormValid ? null : AppColors.primaryGradient,
                  color: _isLoading || !_isFormValid ? AppColors.disabled : null,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _isLoading || !_isFormValid
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
                  onPressed: _isLoading || !_isFormValid ? null : _createCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_rounded, color: AppColors.white),
                            SizedBox(width: 8),
                            Text(
                              'Tạo khóa học',
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
              // Cancel Button
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Hủy bỏ',
                  style: TextStyle(
                    color: _isLoading ? AppColors.disabled : AppColors.secondary,
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