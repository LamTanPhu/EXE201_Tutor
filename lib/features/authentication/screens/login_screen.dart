import 'package:flutter/material.dart';
import 'package:tutor/routes/app_routes.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/authentication/widgets/login_widgets/login_header_widget.dart';
import 'package:tutor/features/authentication/widgets/login_widgets/login_form_widget.dart';
import 'package:tutor/features/authentication/widgets/login_widgets/login_footer_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> handleLogin() async {
      try {
        final response = await ApiService.login(
          emailController.text,
          passwordController.text,
        );
        final token = response['token'];
        final user = response['user'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login successful! Token: $token\nUser: ${user['fullName']}',
            ),
          ),
        );
        Navigator.pushNamed(context, AppRoutes.home);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                  const LoginHeaderWidget(),
                  const SizedBox(height: 40),
                  LoginFormWidget(
                    emailController: emailController,
                    passwordController: passwordController,
                    onLogin: handleLogin,
                  ),
                  const SizedBox(height: 24),
                  LoginFooterWidget(
                    onSignUp: () {
                      Navigator.pushNamed(context, AppRoutes.signup);
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