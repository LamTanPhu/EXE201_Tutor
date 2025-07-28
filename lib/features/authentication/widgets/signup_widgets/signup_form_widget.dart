import 'package:flutter/material.dart';

class SignupFormWidget extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final bool showErrors;
  final VoidCallback onChanged;
  final Future<void> Function() onSignup;

  const SignupFormWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.phoneController,
    required this.showErrors,
    required this.onChanged,
    required this.onSignup,
  });

  @override
  _SignupFormWidgetState createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onSignup();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: const AlwaysStoppedAnimation(1.0),
      child: Column(
        children: [
          TextField(
            controller: widget.nameController,
            decoration: InputDecoration(
              labelText: 'Họ và tên',
              prefixIcon: const Icon(Icons.person_outline, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              errorText: widget.showErrors && widget.nameController.text.trim().isEmpty
                  ? 'Họ và tên là bắt buộc'
                  : null,
            ),
            onChanged: (_) => widget.onChanged(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              errorText: widget.showErrors && widget.emailController.text.trim().isEmpty
                  ? 'Email là bắt buộc'
                  : null,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => widget.onChanged(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.passwordController,
            decoration: InputDecoration(
              labelText: 'Mật khẩu',
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              errorText: widget.showErrors && widget.passwordController.text.trim().isEmpty
                  ? 'Mật khẩu là bắt buộc'
                  : null,
            ),
            obscureText: true,
            onChanged: (_) => widget.onChanged(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.phoneController,
            decoration: InputDecoration(
              labelText: 'Số điện thoại',
              prefixIcon: const Icon(Icons.phone_outlined, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              errorText: widget.showErrors && widget.phoneController.text.trim().isEmpty
                  ? 'Số điện thoại là bắt buộc'
                  : null,
            ),
            keyboardType: TextInputType.phone,
            onChanged: (_) => widget.onChanged(),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isPressed
                      ? [Colors.blue[600]!, Colors.blueAccent[700]!]
                      : [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(_isPressed ? 0.2 : 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.white.withOpacity(0.3),
                highlightColor: Colors.transparent,
                onTap: () {}, // Handled by GestureDetector
                child: const Center(
                  child: Text(
                    'Đăng ký',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}