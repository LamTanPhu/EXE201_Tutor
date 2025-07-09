import 'package:flutter/material.dart';
import 'package:tutor/routes/app_routes.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Tutor Platform',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: Color(0xFF4A90E2)),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.aboutUs);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}