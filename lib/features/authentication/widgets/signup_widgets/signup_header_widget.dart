import 'package:flutter/material.dart';

class SignupHeaderWidget extends StatelessWidget {
  const SignupHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: const AlwaysStoppedAnimation(1.0), // Fade animation placeholder
      child: Column(
        children: [
          Text(
            'Join Us!',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Create an account to start learning.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: Colors.grey[600],
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}