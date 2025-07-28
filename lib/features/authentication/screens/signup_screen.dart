import 'package:flutter/material.dart';
import 'package:tutor/routes/app_routes.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/authentication/widgets/signup_widgets/signup_header_widget.dart';
import 'package:tutor/features/authentication/widgets/signup_widgets/signup_form_widget.dart';
import 'package:tutor/features/authentication/widgets/signup_widgets/signup_footer_widget.dart';

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
  bool _showManualOtpLink = false;

  Future<void> handleSignup() async {
    setState(() {
      _showErrors = true;
      _showManualOtpLink = false;
    });

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ các trường với giá trị hợp lệ')),
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
      if (response['message']?.contains('successfully') ?? false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công! Vui lòng kiểm tra email để nhận OTP.'),
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
          print('Lỗi điều hướng: $e');
        }
        if (!navigated) {
          setState(() {
            _showManualOtpLink = true;
          });
        }
      } else {
        throw Exception('Phản hồi không mong đợi: ${response['message'] ?? 'Không có thông báo'}');
      }
    } catch (e) {
      print('Lỗi đăng ký: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
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
                  const SignupHeaderWidget(),
                  const SizedBox(height: 40),
                  SignupFormWidget(
                    nameController: nameController,
                    emailController: emailController,
                    passwordController: passwordController,
                    phoneController: phoneController,
                    showErrors: _showErrors,
                    onChanged: () {
                      if (_showErrors) {
                        setState(() {});
                      }
                    },
                    onSignup: handleSignup,
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
                          const SnackBar(content: Text('Vui lòng nhập email để xác thực OTP')),
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
    );
  }
}