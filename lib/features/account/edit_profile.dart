import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/snackbar_helper.dart';
import 'package:tutor/common/widgets/custom_app_bar.dart';
import 'package:tutor/services/supabase_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String phone;
  final String avatar;
  final Function(String, String, String, String) onSave;

  const EditProfileScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.onSave,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _avatarUrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.fullName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _avatarUrl = widget.avatar;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      try {
        final uploadedUrl = await SupabaseService.uploadImage(
          file,
          oldFilePath: _avatarUrl,
        );

        if (uploadedUrl != null) {
          setState(() {
            _avatarUrl = uploadedUrl;
          });
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Upload ảnh thành công')),
          // );
          SnackbarHelper.showSuccess(context, "Tải ảnh thành công");
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Lỗi upload ảnh: $e')),
        // );
        SnackbarHelper.showError(context, "Lỗi tải ảnh: $e");
        print(e);
      }
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Chưa chọn ảnh nào')),
      // );
      SnackbarHelper.showWarning(context, "Bạn chưa chọn ảnh nào");
    }
  }

  ImageProvider _buildAvatarImage() {
    if (_avatarUrl == null || _avatarUrl!.isEmpty) {
      return const AssetImage('assets/cat.png');
    } else if (_avatarUrl!.startsWith('http')) {
      return NetworkImage(_avatarUrl!);
    } else {
      return FileImage(File(_avatarUrl!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Chỉnh sửa hồ sơ'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.save),
      //       onPressed: () {
      //         if (_formKey.currentState!.validate()) {
      //           widget.onSave(
      //             _fullNameController.text,
      //             _emailController.text,
      //             _phoneController.text,
      //             _avatarUrl ?? '',
      //           );
      //           Navigator.pop(context);
      //         }
      //       },
      //     ),
      //   ],
      // ),
      appBar: CustomAppBar(
        title: 'Chỉnh sửa hồ sơ',
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSave(
                  _fullNameController.text,
                  _emailController.text,
                  _phoneController.text,
                  _avatarUrl ?? '',
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _buildAvatarImage(),
                      backgroundColor: AppColors.lightPrimary,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator:
                    (value) => value!.isEmpty ? 'Enter your email' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator:
                    (value) => value!.isEmpty ? 'Enter your phone' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
