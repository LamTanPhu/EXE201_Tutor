import 'package:flutter/material.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: const AlwaysStoppedAnimation(1.0),
      child: Column(
        children: [
          Text(
            'Welcome Back!',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A6395), // Updated to darker blue
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Log in to continue your learning journey.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: Color(0xFF34495E),
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}