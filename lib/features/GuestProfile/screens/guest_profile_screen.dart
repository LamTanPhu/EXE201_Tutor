import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:tutor/services/api_service.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/features/home/widgets/home_bottom_nav_bar_widget.dart';

class GuestProfileScreen extends StatefulWidget {
  const GuestProfileScreen({super.key});

  @override
  State<GuestProfileScreen> createState() => _GuestProfileScreenState();
}

class _GuestProfileScreenState extends State<GuestProfileScreen> {
  Account? _profile;
  bool _isLoading = true;
  bool _isEditing = false;
  String _errorMessage = '';
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
        _errorMessage = '';
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
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: $e';
        });

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
        _avatarController.text = picked.path; // For future upload
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
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

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
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _getAvatarImageProvider(),
                  child: _getAvatarImageProvider() == null
                      ? const Icon(Icons.person,
                      size: 60, color: Colors.grey)
                      : null,
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.edit,
                            size: 16, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _buildEditableField('Full Name', _fullNameController),
            const SizedBox(height: 12),
            _buildEditableField('Email', _emailController),
            const SizedBox(height: 12),
            _buildEditableField('Phone', _phoneController),
            const SizedBox(height: 12),
            if (_isEditing)
              _buildEditableField('Avatar URL', _avatarController),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isEditing
                  ? _saveProfile
                  : () => setState(() => _isEditing = true),
              icon: Icon(
                  _isEditing ? Icons.save : Icons.edit_outlined),
              label:
              Text(_isEditing ? 'Save Changes' : 'Edit Profile'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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

  Widget _buildEditableField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        _isEditing
            ? TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),
            isDense: true,
          ),
        )
            : Container(
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            controller.text.isNotEmpty
                ? controller.text
                : 'Not set',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
