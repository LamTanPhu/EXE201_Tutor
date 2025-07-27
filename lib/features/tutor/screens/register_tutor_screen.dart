import 'package:flutter/material.dart';
import 'package:tutor/common/widgets/custom_app_bar.dart';
import 'package:tutor/common/widgets/input_field.dart';
import 'package:tutor/routes/app_routes.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/authentication/widgets/signup_widgets/signup_header_widget.dart';
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
  final TextEditingController confirmPasswordController =
      TextEditingController();
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
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ và hợp lệ các trường thông tin'),
        ),
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

      if (response['message']?.toLowerCase().contains('successfully') ??
          false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Đăng ký thành công! Vui lòng kiểm tra email để lấy mã OTP.',
            ),
          ),
        );
        final result = await Navigator.pushNamed(
          context,
          AppRoutes.verifyOtp,
          arguments: emailController.text.trim(),
        );
        if (result == null) {
          setState(() {
            _showManualOtpLink = true;
          });
        }
      } else {
        throw Exception(
          'Phản hồi không mong đợi: ${response['message'] ?? 'Không có thông điệp'}',
        );
      }
    } catch (e) {
      print('Lỗi đăng ký Tutor: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Đăng ký làm gia sư'),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      const SignupHeaderWidget(),
                      const SizedBox(height: 40),
                      InputFieldWidget(
                        controller: nameController,
                        label: 'Họ và tên',
                        validator:
                            (val) => InputValidators.required(val, 'họ và tên'),
                      ),
                      InputFieldWidget(
                        controller: emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: InputValidators.email,
                      ),
                      InputFieldWidget(
                        controller: phoneController,
                        label: 'Số điện thoại',
                        keyboardType: TextInputType.phone,
                        validator: InputValidators.phone,
                      ),
                      InputFieldWidget(
                        controller: passwordController,
                        label: 'Mật khẩu',
                        obscureText: true,
                        validator:
                            (val) =>
                                InputValidators.minLength(val, 6, 'mật khẩu'),
                      ),
                      InputFieldWidget(
                        controller: confirmPasswordController,
                        label: 'Xác nhận mật khẩu',
                        obscureText: true,
                        validator: (val) {
                          if (val != passwordController.text)
                            return 'Mật khẩu không khớp';
                          return InputValidators.required(
                            val,
                            'xác nhận mật khẩu',
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: handleRegisterTutor,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Đăng ký',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SignupFooterWidget(
                        showManualOtpLink: _showManualOtpLink,
                        email: emailController.text.trim(),
                        onLogin: () => Navigator.pop(context),
                        onManualOtp: () {
                          if (emailController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Vui lòng nhập email để xác thực OTP',
                                ),
                              ),
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
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
