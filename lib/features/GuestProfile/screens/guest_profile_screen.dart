import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tutor/services/api_service.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/features/home/widgets/home_bottom_nav_bar_widget.dart';
import 'package:tutor/features/GuestProfile/widgets/avatar_edit_widget.dart';
import 'package:tutor/features/GuestProfile/widgets/profile_form_widget.dart';

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
          SnackBar(content: Text('Error fetching profile: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
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
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
          ? const Center(child: Text('Failed to load profile'))
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
        selectedIndex: 3,
        onItemTapped: (index) {
          Navigator.pushReplacementNamed(context, [
            '/home',
            '/home',
            '/forum',
            '/guest',
          ][index]);
        },
      ),
    );
  }
}
