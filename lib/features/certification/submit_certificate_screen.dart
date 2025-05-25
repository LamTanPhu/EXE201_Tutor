import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String? resultMessage;

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
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name of the certicaiton',
                ),
                validator: (value) => value!.isEmpty ? 'required' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'required' : null,
              ),
              TextFormField(
                controller: experienceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Experience'),
                validator: (value) => value!.isEmpty ? 'required' : null,
              ),
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Pick image'),
              ),
              if (_imageFiles.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imageFiles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            Image.file(
                              _imageFiles[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _imageFiles.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
              if (resultMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  resultMessage!,
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
