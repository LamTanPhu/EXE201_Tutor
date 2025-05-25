import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor/common/utils/shared_prefs.dart';
import 'package:tutor/routes/app_routes.dart';
import 'package:tutor/services/api_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Log in to continue your learning journey.',
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
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final response = await ApiService.login(
                      emailController.text,
                      passwordController.text,
                    );
                    // Handle successful login
                    final token = response['token'];
                    final user = response['user'];
                    final role = user['role'];

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Login successful! Token: $token\nUser: ${user['fullName']}',
                        ),
                      ),
                    );

                    //save token and role
                    final prefs = await SharedPreferences.getInstance();
                    await SharedPrefs.saveToken(token);
                    await prefs.setString('role', role);
                    await prefs.setString('fullName', user['fullName']);
                    // Navigate to home screen
                    // Navigator.pushNamed(context, AppRoutes.home);
                    //Navigate base on account's role
                    switch (role) {
                      case 'Admin':
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.adminDashboard,
                        );
                        break;
                      case 'Tutor':
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.tutorMain,
                        );
                      default:
                        Navigator.pushNamed(context, AppRoutes.home);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                },
                child: const Text(
                  'Don’t have an account? Sign Up',
                  style: TextStyle(color: Color(0xFF007BFF)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.tutor);
                },
                child: const Text(
                  'Become a Tutor? Sign Up as Tutor',
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
