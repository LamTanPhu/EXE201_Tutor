import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/common/utils/currency.dart';

class ProfileCardWidget extends StatefulWidget {
  final Account profile;
  final bool isEditing;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final GlobalKey<FormState> formKey;

  const ProfileCardWidget({
    super.key,
    required this.profile,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [AppColors.lightPrimary, AppColors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
              const Divider(height: 30, thickness: 1),
              _buildFieldOrText(
                icon: Icons.person,
                label: 'Full Name',
                isEditing: widget.isEditing,
                controller: widget.fullNameController,
                value: widget.profile.fullName ?? "N/A",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 12),
              _buildFieldOrText(
                icon: Icons.email,
                label: 'Email',
                isEditing: widget.isEditing,
                controller: widget.emailController,
                value: widget.profile.email ?? "N/A",
                validator: (value) => value!.contains('@')
                    ? null
                    : 'Please enter a valid email',
              ),
              const SizedBox(height: 12),
              _buildFieldOrText(
                icon: Icons.phone,
                label: 'Phone',
                isEditing: widget.isEditing,
                controller: widget.phoneController,
                value: widget.profile.phone ?? "Not provided",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Balance: ${CurrencyUtils.formatVND(widget.profile.balance ?? 0)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldOrText({
    required IconData icon,
    required String label,
    required bool isEditing,
    required TextEditingController controller,
    required String value,
    required String? Function(String?) validator,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 12),
        Expanded(
          child: isEditing
              ? TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                    border: const OutlineInputBorder(),
                  ),
                  validator: validator,
                )
              : Text(
                  '$label: $value',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
        ),
      ],
    );
  }
}
