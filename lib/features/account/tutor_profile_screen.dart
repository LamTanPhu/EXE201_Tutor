import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/features/account/edit_profile.dart';
import 'package:tutor/features/account/widgets/certification_card_widget.dart';
import 'package:tutor/features/account/widgets/profile_avatar_widget.dart';
import 'package:tutor/features/account/widgets/profile_card_widget.dart';
import 'package:tutor/routes/app_routes.dart';
import 'package:tutor/services/api_service.dart';

class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  _TutorProfileScreenState createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  late Future<Account> profile;

  @override
  void initState() {
    super.initState();
    profile = ApiService.getProfile();
  }

  void _addCertification() {
    Navigator.pushNamed(context, AppRoutes.ceritificationUpload);
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  void _navigateToEditProfile(Account profileData) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          fullName: profileData.fullName ?? '',
          email: profileData.email ?? '',
          phone: profileData.phone ?? '',
          avatar: profileData.avatar ?? '',
          onSave: (fullName, email, phone, avatar) async {
            await ApiService.updateAccountProfile(fullName, email, phone, avatar);
            setState(() {
              profile = ApiService.getProfile();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          },
        ),
      ),
    );
    setState(() {
      profile = ApiService.getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          FutureBuilder<Account>(
            future: profile,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _navigateToEditProfile(snapshot.data!),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Account>(
        future: profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No profile data found.'));
          }

          final profileData = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileAvatarWidget(avatarUrl: profileData.avatar),
                  const SizedBox(height: 24),
                  ProfileCardWidget(
                    profile: profileData,
                    isEditing: false,
                    fullNameController: TextEditingController(text: profileData.fullName),
                    emailController: TextEditingController(text: profileData.email),
                    phoneController: TextEditingController(text: profileData.phone),
                    formKey: GlobalKey<FormState>(),
                  ),
                  const SizedBox(height: 24),
                  CertificationCardWidget(
                    onAddCertification: _addCertification,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => logout(context),
                      child: const Icon(Icons.logout),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}