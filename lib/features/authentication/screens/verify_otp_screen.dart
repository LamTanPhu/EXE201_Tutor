import 'package:flutter/material.dart';
import 'package:tutor/routes/app_routes.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/authentication/widgets/otp_widgets/verify_otp_header_widget.dart';
import 'package:tutor/features/authentication/widgets/otp_widgets/verify_otp_form_widget.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String? email;

  const VerifyOtpScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();
    final TextEditingController emailController = TextEditingController(text: email ?? '');

    Future<void> handleVerifyOtp() async {
      try {
        final response = await ApiService.verifyOtp(
          emailController.text,
          otpController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verified successfully!')),
        );
        Navigator.pushNamed(context, AppRoutes.login);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.white,
            ],
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
                  const VerifyOtpHeaderWidget(),
                  const SizedBox(height: 40),
                  VerifyOtpFormWidget(
                    emailController: emailController,
                    otpController: otpController,
                    isEmailEnabled: email == null,
                    onVerifyOtp: handleVerifyOtp,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}