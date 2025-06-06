import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor/common/models/course.dart';
import 'package:tutor/common/widgets/image_preview.dart';
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
  bool _isFormValid = false;

  String? resultMessage;

  @override
  void initState() {
    // TODO: implement initState

    _nameController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
    _priceController.addListener(_validateForm);
    _validateForm();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final uploadedUrl = await SupabaseService.uploadImage(file);

      if (uploadedUrl != null) {
        setState(() {
          _selectedImage = uploadedUrl; // chỉ lưu URL
        });
        _validateForm();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to upload image')));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No image selected')));
    }
  }

  void _validateForm() {
    final isValid =
        _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        double.tryParse(_priceController.text) != null &&
        _selectedImage != null;
  print('Validating: isValid = $isValid');

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.parse(_priceController.text);

      await ApiService.createCourse(
        name: name,
        description: description,
        image: _selectedImage,
        price: price,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course created successfully')),
        );
        final course = Course(
          name: name,
          description: description,
          image: _selectedImage ?? '',
          price: price,
        );
        // Đảm bảo pop sau khi SnackBar đã hiển thị
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) Navigator.pop(context, course);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputFieldWidget(
                  controller: _nameController,
                  label: "Name of Coure",
                ),
                InputFieldWidget(
                  controller: _descriptionController,
                  label: "Description",
                  maxLines: 3,
                ),
                InputFieldWidget(
                  controller: _priceController,
                  label: "Price",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) < 0) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ImagePreviewWidget(
                  imageFile: _selectedImage,
                  onTap: _pickImage,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isFormValid ? _createCourse : null,
                        child: const Text('Create Course'),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
