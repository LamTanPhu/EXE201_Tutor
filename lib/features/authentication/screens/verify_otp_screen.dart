import 'package:flutter/material.dart';
import 'package:tutor/routes/app_routes.dart';
import 'package:tutor/services/api_service.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String? email; // Receive email from signup screen

  const VerifyOtpScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    // Pre-fill email if provided
    final emailController = TextEditingController(text: email ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Verify Your OTP',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Enter the OTP sent to your email.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                enabled: email == null, // Disable if email is pre-filled
              ),
              const SizedBox(height: 16),
              TextField(
                controller: otpController,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final response = await ApiService.verifyOtp(
                      emailController.text,
                      otpController.text,
                    );
                    // Handle successful OTP verification
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OTP verified successfully!')),
                    );
                    // Navigate to login screen
                    Navigator.pushNamed(context, AppRoutes.login);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: const Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}