import 'package:flutter/material.dart';
import 'editable_field_widget.dart';

class ProfileFormWidget extends StatelessWidget {
  final bool isEditing;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController avatarController;
  final VoidCallback onEditToggle;
  final VoidCallback onSave;

  const ProfileFormWidget({
    super.key,
    required this.isEditing,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.avatarController,
    required this.onEditToggle,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditableFieldWidget(
          label: 'Full Name',
          controller: fullNameController,
          isEditing: isEditing,
        ),
        const SizedBox(height: 12),
        EditableFieldWidget(
          label: 'Email',
          controller: emailController,
          isEditing: isEditing,
        ),
        const SizedBox(height: 12),
        EditableFieldWidget(
          label: 'Phone',
          controller: phoneController,
          isEditing: isEditing,
        ),
        const SizedBox(height: 12),
        if (isEditing)
          EditableFieldWidget(
            label: 'Avatar URL',
            controller: avatarController,
            isEditing: isEditing,
          ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: isEditing ? onSave : onEditToggle,
          icon: Icon(isEditing ? Icons.save : Icons.edit_outlined),
          label: Text(isEditing ? 'Save Changes' : 'Edit Profile'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
