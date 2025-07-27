import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor/common/utils/shared_prefs.dart';
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
    final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

    Future<void> handleLogin() async {
      if (isLoading.value) return; // Prevent multiple taps
      isLoading.value = true;
      try {
        final response = await ApiService.login(
          emailController.text,
          passwordController.text,
        );
        final token = response['token'];
        final user = response['user'];
        final role = user['role'];
        final fullName = user['fullName'];
        final accountId = user['id'];

        await SharedPrefs.saveToken(token); //save token
        await SharedPrefs.saveAccountId(accountId);
        await SharedPrefs.saveFullName(fullName);
        await SharedPrefs.saveRole(role);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login successful! Welcome, $fullName',
            ),
          ),
        );
        //get user role to navigate
        switch(role){
          case 'Admin':
            Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
            break;
          case 'Tutor':
            Navigator.pushReplacementNamed(context, AppRoutes.tutorMain);
            break;
          default:
            Navigator.pushReplacementNamed(context, AppRoutes.overview);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFFF5F7FA)], // Updated to bluish gradient
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Expanded(
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
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.tutor);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF4A90E2), // Updated to blue
                          ),
                          child: const Text(
                            'Become a Tutor? Sign Up as Tutor',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}