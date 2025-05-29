import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/features/account/widgets/certification_card_widget.dart';
import 'package:tutor/features/account/widgets/profile_avatar_widget.dart';
import 'package:tutor/features/account/widgets/profile_card_widget.dart';
import 'package:tutor/services/api_service.dart';

class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  _TutorProfileScreenState createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  late Future<Account> profile;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    profile = ApiService.getProfile();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  void _toggleEditMode(Account profile) {
    setState(() {
      if (!_isEditing) {
        _fullNameController.text = profile.fullName ?? '';
        _emailController.text = profile.email ?? '';
        _phoneController.text = profile.phone ?? '';
      }
      _isEditing = !_isEditing;
    });
  }

  void _addCertification() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Certification'),
            content: const Text(
              'Feature to upload certification comming soon!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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

          final profile = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileAvatarWidget(avatarUrl: profile.avatar),
                  const SizedBox(height: 24),
                  ProfileCardWidget(
                    profile: profile,
                    isEditing: _isEditing,
                    fullNameController: _fullNameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    formKey: _formKey,
                  ),

                  const SizedBox(height: 24),
                  CertificationCardWidget(onAddCertification: _addCertification)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
