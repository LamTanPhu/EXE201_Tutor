import 'package:flutter/material.dart';
import 'package:tutor/routes/app_routes.dart';
import 'package:tutor/services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool _showErrors = false;
  bool _showManualOtpLink = false; // Control visibility of the manual OTP link

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                'Join Us!',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Create an account to start learning.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _showErrors && nameController.text.trim().isEmpty
                      ? 'Full name is required'
                      : null,
                ),
                onChanged: (value) {
                  if (_showErrors) {
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _showErrors && emailController.text.trim().isEmpty
                      ? 'Email is required'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  if (_showErrors) {
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _showErrors && passwordController.text.trim().isEmpty
                      ? 'Password is required'
                      : null,
                ),
                obscureText: true,
                onChanged: (value) {
                  if (_showErrors) {
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _showErrors && phoneController.text.trim().isEmpty
                      ? 'Phone number is required'
                      : null,
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  if (_showErrors) {
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _showErrors = true;
                    _showManualOtpLink = false; // Reset the manual link visibility
                  });

                  print('Name: ${nameController.text}');
                  print('Email: ${emailController.text}');
                  print('Password: ${passwordController.text}');
                  print('Phone: ${phoneController.text}');

                  if (nameController.text.trim().isEmpty ||
                      emailController.text.trim().isEmpty ||
                      passwordController.text.trim().isEmpty ||
                      phoneController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields with valid values')),
                    );
                    return;
                  }

                  try {
                    final response = await ApiService.register(
                      nameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      phoneController.text.trim(),
                    );
                    print('Signup Response: $response');
                    if (response['message']?.contains('successfully') ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration successful! Please check your email for OTP.'),
                        ),
                      );
                      print('Attempting to navigate to VerifyOtpScreen with email: ${emailController.text.trim()}');
                      bool navigated = false;
                      try {
                        final result = await Navigator.pushNamed(
                          context,
                          AppRoutes.verifyOtp,
                          arguments: emailController.text.trim(),
                        );
                        navigated = result != null; // Check if navigation succeeded
                      } catch (e) {
                        print('Navigation Error: $e');
                      }
                      if (!navigated) {
                        setState(() {
                          _showManualOtpLink = true; // Show manual link if navigation fails
                        });
                      }
                    } else {
                      throw Exception('Unexpected response: ${response['message'] ?? 'No message'}');
                    }
                  } catch (e) {
                    print('Signup Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Color(0xFF007BFF)),
                ),
              ),
              if (_showManualOtpLink) // Only show if navigation fails
                TextButton(
                  onPressed: () {
                    if (emailController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter an email to verify OTP')),
                      );
                      return;
                    }
                    print('Manually navigating to VerifyOtpScreen with email: ${emailController.text.trim()}');
                    Navigator.pushNamed(
                      context,
                      AppRoutes.verifyOtp,
                      arguments: emailController.text.trim(),
                    );
                  },
                  child: const Text(
                    'Didn’t get OTP? Verify manually',
                    style: TextStyle(color: Color(0xFF007BFF)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}