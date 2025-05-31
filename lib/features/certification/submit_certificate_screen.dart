import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor/common/widgets/image_prveview_list.dart';
import 'package:tutor/common/widgets/input_field.dart';
import 'package:tutor/common/widgets/pick_image_button.dart';
import 'package:tutor/services/api_service.dart';

class SubmitCertificationScreen extends StatefulWidget {
  const SubmitCertificationScreen({super.key});

  @override
  State<SubmitCertificationScreen> createState() =>
      _SubmitCertificationScreenState();
}

class _SubmitCertificationScreenState extends State<SubmitCertificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final experienceController = TextEditingController();
  final List<File> _imageFiles = [];

  bool isLoading = false;
  bool _isFormValid = false;
  String? resultMessage;

  @override
  void initState() {
    // TODO: implement initState

    nameController.addListener(_validateForm);
    descriptionController.addListener(_validateForm);
    experienceController.addListener(_validateForm);
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
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(); // Chọn nhiều ảnh
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
      //take the image link
      final cert = await ApiService.submitCertification(
        name: nameController.text,
        description: descriptionController.text,
        imageFiles: _imageFiles,
        experience: int.parse(experienceController.text),
      );

      setState(() {
        resultMessage = 'Submit: ${cert.name} successfully';
        _imageFiles.clear();
        nameController.clear();
        descriptionController.clear();
        experienceController.clear();
      });
    } catch (e) {
      setState(() {
        resultMessage = 'Error: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Certification')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputFieldWidget(
                controller: nameController,
                label: 'Name of the certification',
              ),
              InputFieldWidget(
                controller: descriptionController,
                label: 'Description',
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              InputFieldWidget(
                controller: experienceController,
                label: 'Experience',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter a price';
                  final price = double.tryParse(value);
                  if (price == null || price < 0)
                    return 'Price must be a positive number';
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
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                   : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isFormValid ? _submit : null,
                        child: const Text('Submit'),
                      ),
                  ),
              if (resultMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  resultMessage!,
                  style: TextStyle(
                    color:
                        resultMessage!.startsWith('Error')
                            ? Colors.red
                            : Colors.green,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
