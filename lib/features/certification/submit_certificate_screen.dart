import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/widgets/custom_app_bar.dart';
import 'package:tutor/common/widgets/image_prveview_list.dart';
import 'package:tutor/common/widgets/input_field.dart';

class SubmitCertificationScreen extends StatefulWidget {
  const SubmitCertificationScreen({super.key});

  @override
  State<SubmitCertificationScreen> createState() =>
      _SubmitCertificationScreenState();
}

class _SubmitCertificationScreenState extends State<SubmitCertificationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final experienceController = TextEditingController();
  final List<File> _imageFiles = [];

  bool isLoading = false;
  bool _isFormValid = false;
  String? resultMessage;
  late AnimationController _animationController;

@override
void initState() {
  super.initState();

  _animationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  nameController.addListener(_validateForm);
  descriptionController.addListener(_validateForm);
  experienceController.addListener(_validateForm);
}

  @override
  void dispose() {
    _animationController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid =
        nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        experienceController.text.isNotEmpty &&
        int.tryParse(experienceController.text) != null;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
      if (isValid) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _imageFiles.addAll(pickedFiles.map((file) => File(file.path)));
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      resultMessage = null;
    });

    try {
      // Mock API call - replace with ApiService.submitCertification
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        resultMessage = 'Gửi chứng chỉ "${nameController.text}" thành công!';
        _imageFiles.clear();
        nameController.clear();
        descriptionController.clear();
        experienceController.clear();
      });
    } catch (e) {
      setState(() {
        resultMessage = 'Lỗi: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Nộp chứng chỉ',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user, color: Colors.white, size: 32),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nộp chứng chỉ mới',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Thêm chứng chỉ để nâng cao uy tín của bạn',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Form Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InputFieldWidget(
                        controller: nameController,
                        label: 'Tên chứng chỉ',
                        hint: 'Ví dụ: Flutter Developer Certificate',
                        prefixIcon: Icons.card_membership,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên chứng chỉ';
                          }
                          return null;
                        },
                      ),
                      InputFieldWidget(
                        controller: descriptionController,
                        label: 'Mô tả',
                        hint: 'Mô tả chi tiết về chứng chỉ...',
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        prefixIcon: Icons.description,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mô tả';
                          }
                          return null;
                        },
                      ),
                      InputFieldWidget(
                        controller: experienceController,
                        label: 'Kinh nghiệm (năm)',
                        hint: 'Số năm kinh nghiệm liên quan',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.timeline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số năm kinh nghiệm';
                          }
                          final experience = int.tryParse(value);
                          if (experience == null || experience < 0) {
                            return 'Kinh nghiệm phải là số dương';
                          }
                          return null;
                        },
                      ),
                      ImagePreviewList(
                        imageFiles: _imageFiles,
                        onRemove: (index) {
                          setState(() {
                            _imageFiles.removeAt(index);
                          });
                        },
                        onTap: _pickImages,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Submit Button
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.95 + (0.05 * _animationController.value),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient:
                              _isFormValid
                                  ? AppColors.primaryGradient
                                  : LinearGradient(
                                    colors: [
                                      AppColors.disabled,
                                      AppColors.disabled,
                                    ],
                                  ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow:
                              _isFormValid
                                  ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                                  : [],
                        ),
                        child: ElevatedButton(
                          onPressed:
                              (_isFormValid && !isLoading) ? _submit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Nộp chứng chỉ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                    );
                  },
                ),

                // Result Message
                if (resultMessage != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          resultMessage!.startsWith('Lỗi')
                              ? AppColors.error.withOpacity(0.1)
                              : AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            resultMessage!.startsWith('Lỗi')
                                ? AppColors.error
                                : AppColors.success,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          resultMessage!.startsWith('Lỗi')
                              ? Icons.error_outline
                              : Icons.check_circle_outline,
                          color:
                              resultMessage!.startsWith('Lỗi')
                                  ? AppColors.error
                                  : AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            resultMessage!,
                            style: TextStyle(
                              color:
                                  resultMessage!.startsWith('Lỗi')
                                      ? AppColors.error
                                      : AppColors.success,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Tips Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.tips_and_updates, color: AppColors.info),
                          SizedBox(width: 8),
                          Text(
                            'Lời khuyên',
                            style: TextStyle(
                              color: AppColors.info,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTip('Chọn ảnh chứng chỉ rõ nét, đầy đủ thông tin'),
                      _buildTip('Mô tả chi tiết để tăng độ tin cậy'),
                      _buildTip(
                        'Chứng chỉ sẽ được xét duyệt trong 1-3 ngày làm việc',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.info,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.info, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
