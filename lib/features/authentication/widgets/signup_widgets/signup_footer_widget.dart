import 'package:flutter/material.dart';

class SignupFooterWidget extends StatelessWidget {
  final bool showManualOtpLink;
  final String email;
  final VoidCallback onLogin;
  final VoidCallback onManualOtp;

  const SignupFooterWidget({
    super.key,
    required this.showManualOtpLink,
    required this.email,
    required this.onLogin,
    required this.onManualOtp,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: const AlwaysStoppedAnimation(1.0), // Fade animation placeholder
      child: Column(
        children: [
          TextButton(
            onPressed: onLogin,
            child: const Text(
              'Đã có tài khoản? Đăng nhập', // Corrected typo from 'Đã các tài khoản' to 'Đã có tài khoản'
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (showManualOtpLink)
            TextButton(
              onPressed: onManualOtp,
              child: const Text(
                'Không nhận được OTP? Xác thực thủ công',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}