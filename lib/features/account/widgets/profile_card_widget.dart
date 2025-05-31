import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';

class ProfileCardWidget extends StatefulWidget {
  final Account profile;
  //final VoidCallback onToggleEdit;
  //final VoidCallback onSave;
  final bool isEditing;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final GlobalKey<FormState> formKey;

  const ProfileCardWidget({
    super.key,
    required this.profile,
    //required this.onToggleEdit,
    //required this.onSave,
    required this.isEditing,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.formKey,
  });

  @override
  State<ProfileCardWidget> createState() => _ProfileCardWidgetState();
}

class _ProfileCardWidgetState extends State<ProfileCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              widget.isEditing
                  ? TextFormField(
                    controller: widget.fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Please enter your name' : null,
                  )
                  : Text(
                    'Full Name: ${widget.profile.fullName}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              const SizedBox(height: 12),
              widget.isEditing
                  ? TextFormField(
                    controller: widget.emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value!.contains('@')
                                ? null
                                : 'Please enter a valid email',
                  )
                  : Text(
                    'Email: ${widget.profile.email}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              const SizedBox(height: 12),
              widget.isEditing
                  ? TextFormField(
                    controller: widget.phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? 'Please enter your phone number'
                                : null,
                  )
                  : Text(
                    'Phone: ${widget.profile.phone ?? 'Not provided'}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              const SizedBox(height: 12),
              Text(
                'Balance: ${widget.profile.balance?.toStringAsFixed(0) ?? '0'} VND',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
