import 'package:flutter/material.dart';

class LoginFooterWidget extends StatelessWidget {
  final VoidCallback onSignUp;

  const LoginFooterWidget({super.key, required this.onSignUp});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(1.0), // Fade animation placeholder
      child: TextButton(
        onPressed: onSignUp,
        child: const Text(
          'Don’t have an account? Sign Up',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}