import 'package:flutter/material.dart';
import 'package:tutor/routes/app_routes.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/authentication/widgets/signup_widgets/signup_header_widget.dart';
import 'package:tutor/features/tutor/widgets/tutor_signup_form_widget.dart';
import 'package:tutor/features/authentication/widgets/signup_widgets/signup_footer_widget.dart';

class RegisterTutorScreen extends StatefulWidget {
  const RegisterTutorScreen({super.key});

  @override
  _RegisterTutorScreenState createState() => _RegisterTutorScreenState();
}

class _RegisterTutorScreenState extends State<RegisterTutorScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _showErrors = false;
  bool _showManualOtpLink = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> handleRegisterTutor() async {
    setState(() {
      _showErrors = true;
      _showManualOtpLink = false;
      _isLoading = true;
    });

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        !emailController.text.contains('@') ||
        phoneController.text.length != 10 ||
        passwordController.text.length < 6 ||
        passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields with valid values')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await ApiService.registerTutor(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        phoneController.text.trim(),
      );

      if (response['message']?.toLowerCase().contains('successfully') ?? false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please check your email for OTP.'),
          ),
        );
        bool navigated = false;
        try {
          final result = await Navigator.pushNamed(
            context,
            AppRoutes.verifyOtp,
            arguments: emailController.text.trim(),
          );
          navigated = result != null;
        } catch (e) {
          print('Navigation Error: $e');
        }
        if (!navigated) {
          setState(() {
            _showManualOtpLink = true;
          });
        }
      } else {
        throw Exception('Unexpected response: ${response['message'] ?? 'No message'}');
      }
    } catch (e) {
      print('Tutor Signup Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Tutor'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[50]!, Colors.white],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      const SignupHeaderWidget(), // Reuse from SignupScreen
                      const SizedBox(height: 40),
                      TutorSignupFormWidget(
                        nameController: nameController,
                        emailController: emailController,
                        passwordController: passwordController,
                        phoneController: phoneController,
                        confirmPasswordController: confirmPasswordController,
                        showErrors: _showErrors,
                        isPasswordVisible: _isPasswordVisible,
                        onTogglePasswordVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        onChanged: () {
                          if (_showErrors) {
                            setState(() {});
                          }
                        },
                        onSignup: handleRegisterTutor,
                      ),
                      const SizedBox(height: 24),
                      SignupFooterWidget(
                        showManualOtpLink: _showManualOtpLink,
                        email: emailController.text.trim(),
                        onLogin: () {
                          Navigator.pop(context);
                        },
                        onManualOtp: () {
                          if (emailController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter an email to verify OTP')),
                            );
                            return;
                          }
                          Navigator.pushNamed(
                            context,
                            AppRoutes.verifyOtp,
                            arguments: emailController.text.trim(),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}