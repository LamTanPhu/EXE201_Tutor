// lib/features/tutor/widgets/tutor_signup_form_widget.dart
import 'package:flutter/material.dart';

class TutorSignupFormWidget extends StatelessWidget{
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final TextEditingController confirmPasswordController;
  final bool showErrors;
  final bool isPasswordVisible;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onChanged;
  final VoidCallback onSignup;

  const TutorSignupFormWidget({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.confirmPasswordController,
    required this.showErrors,
    required this.isPasswordVisible,
    required this.onTogglePasswordVisibility,
    required this.onChanged,
    required this.onSignup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
            errorText: showErrors && nameController.text.trim().isEmpty
                ? 'Please enter your full name'
                : null,
          ),
          onChanged: (_) => onChanged,),
        const SizedBox(height: 16),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
            errorText: showErrors && !emailController.text.contains('@')
                ? 'Invalid email address'
                : null,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
            errorText: showErrors && phoneController.text.length != 10
                ? 'Phone number must be 10 digits'
                : null,
          ),
          keyboardType: TextInputType.phone,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: passwordController,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: onTogglePasswordVisibility,
            ),
            errorText: showErrors && passwordController.text.length < 6
                ? 'Password must be at least 6 characters'
                : null,
          ),
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: confirmPasswordController,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: onTogglePasswordVisibility,
            ),
            errorText: showErrors &&
                    (confirmPasswordController.text.isEmpty ||
                        confirmPasswordController.text !=
                            passwordController.text)
                ? 'Passwords do not match'
                : null,
          ),
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onSignup,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Register as Tutor'),
        ),
      ],
    );
  }
}