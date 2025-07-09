import 'package:flutter/material.dart';

class LoginFooterWidget extends StatelessWidget {
  final VoidCallback onSignUp;

  const LoginFooterWidget({super.key, required this.onSignUp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextButton(
        onPressed: onSignUp,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF4CAF50),
        ),
        child: const Text(
          'Don’t have an account? Sign Up',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}