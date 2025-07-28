import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tutor/services/api_service.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/features/home/widgets/home_bottom_nav_bar_widget.dart';
import 'package:tutor/features/GuestProfile/widgets/avatar_edit_widget.dart';
import 'package:tutor/features/GuestProfile/widgets/profile_form_widget.dart';
import 'package:tutor/routes/app_routes.dart';

class GuestProfileScreen extends StatefulWidget {
  const GuestProfileScreen({super.key});

  @override
  State<GuestProfileScreen> createState() => _GuestProfileScreenState();
}

class _GuestProfileScreenState extends State<GuestProfileScreen> {
  Account? _profile;
  bool _isLoading = true;
  bool _isEditing = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final profileData = await ApiService.getGuestAccountProfile()
          .timeout(const Duration(seconds: 10));

      if (mounted) {
        setState(() {
          _profile = profileData;
          _fullNameController.text = _profile?.fullName ?? '';
          _emailController.text = _profile?.email ?? '';
          _phoneController.text = _profile?.phone ?? '';
          _avatarController.text = _profile?.avatar ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải hồ sơ: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ các trường bắt buộc')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedProfile = await ApiService.updateGuestAccountProfile(
        _fullNameController.text,
        _emailController.text,
        _phoneController.text,
        _avatarController.text,
      ).timeout(const Duration(seconds: 10));

      if (mounted) {
        setState(() {
          _profile = updatedProfile;
          _isEditing = false;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật hồ sơ thành công')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật hồ sơ: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
        _avatarController.text = picked.path;
      });
    }
  }

  ImageProvider? _getAvatarImageProvider() {
    if (_pickedImage != null) return FileImage(_pickedImage!);
    final avatarUrl = _profile?.avatar;
    if (avatarUrl == null || avatarUrl.isEmpty) return null;
    try {
      final uri = Uri.parse(avatarUrl);
      if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) return null;
    } catch (_) {
      return null;
    }
    return NetworkImage(avatarUrl);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      // Update selected index for visual feedback
    });
    switch (index) {
      case 0: // Tutor mode
        Navigator.pushReplacementNamed(context, AppRoutes.home, arguments: true);
        break;
      case 1: // Course mode
        Navigator.pushReplacementNamed(context, AppRoutes.home, arguments: false);
        break;
      case 2: // Forum
        Navigator.pushNamed(context, AppRoutes.forum);
        break;
      case 3: // Overview
        Navigator.pushReplacementNamed(context, AppRoutes.overview);
        break;
      case 4: // Guest (no additional navigation needed, already here)
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
          ? const Center(child: Text('Không thể tải hồ sơ'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AvatarEditorWidget(
              imageProvider: _getAvatarImageProvider(),
              isEditing: _isEditing,
              onEditPressed: _pickImage,
            ),
            const SizedBox(height: 24),
            ProfileFormWidget(
              isEditing: _isEditing,
              fullNameController: _fullNameController,
              emailController: _emailController,
              phoneController: _phoneController,
              avatarController: _avatarController,
              onEditToggle: () =>
                  setState(() => _isEditing = true),
              onSave: _saveProfile,
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBarWidget(
        selectedIndex: 4, // Updated to 4 for Profile
        onItemTapped: _onItemTapped,
      ),
    );
  }
}