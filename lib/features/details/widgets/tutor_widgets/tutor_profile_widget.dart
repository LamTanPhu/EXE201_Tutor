import 'package:flutter/material.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/tutor_contact_info_widget.dart';
import 'package:tutor/features/details/widgets/tutor_widgets/gradient_button_widget.dart';

class TutorProfileWidget extends StatelessWidget {
  final String fullName;
  final String role;
  final String bio;
  final String email;
  final String phone;
  final String status;

  const TutorProfileWidget({
    super.key,
    required this.fullName,
    required this.role,
    required this.bio,
    required this.email,
    required this.phone,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hồ sơ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[100],
                    child: Text(
                      fullName.isNotEmpty ? fullName[0] : 'G',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Vai trò: $role',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Colors.grey[600],
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Tiểu sử',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                bio,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Thông tin liên hệ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              TutorContactInfoWidget(label: 'Email', value: email),
              TutorContactInfoWidget(label: 'Điện thoại', value: phone),
              TutorContactInfoWidget(label: 'Trạng thái', value: status),
              const SizedBox(height: 20),
              Center(
                child: GradientButtonWidget(
                  text: 'Liên hệ gia sư',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}