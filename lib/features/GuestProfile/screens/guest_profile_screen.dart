import 'package:flutter/material.dart';
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
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final profileData = await ApiService.getGuestAccountProfile();
      setState(() {
        _profile = profileData;
        _fullNameController.text = _profile?.fullName ?? '';
        _emailController.text = _profile?.email ?? '';
        _phoneController.text = _profile?.phone ?? '';
        _avatarController.text = _profile?.avatar ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (_fullNameController.text.isEmpty || _emailController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedProfile = await ApiService.updateGuestAccountProfile(
        _fullNameController.text,
        _emailController.text,
        _phoneController.text,
        _avatarController.text.isEmpty ? '' : _avatarController.text, // Ensure non-null string
      );
      setState(() {
        _profile = updatedProfile;
        _isEditing = false;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
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
        title: const Text('Guest Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _profile?.avatar != null && _profile!.avatar!.isNotEmpty
                  ? NetworkImage(_profile!.avatar!)
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
              child: _isEditing
                  ? IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: () {
                  // Handle avatar update (e.g., image picker)
                },
              )
                  : null,
            ),
            const SizedBox(height: 16),
            if (_isEditing)
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              )
            else
              Text(
                _profile?.fullName ?? 'No Name',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 8),
            if (_isEditing)
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              )
            else
              Text(
                _profile?.email ?? 'No Email',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            const SizedBox(height: 8),
            if (_isEditing)
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              )
            else
              Text(
                _profile?.phone ?? 'No Phone',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            const SizedBox(height: 8),
            if (_isEditing)
              TextField(
                controller: _avatarController,
                decoration: const InputDecoration(
                  labelText: 'Avatar URL',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isEditing
                  ? _saveProfile
                  : () => setState(() => _isEditing = true),
              child: Text(_isEditing ? 'Save' : 'Edit Profile'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBarWidget(
        selectedIndex: 3, // Profile tab is index 3
        onItemTapped: (index) {
          if (index != 3) {
            Navigator.pushReplacementNamed(context, [
              '/home',
              '/home',
              '/forum',
              '/guest-profile',
            ][index]);
          }
        },
      ),
    );
  }
}