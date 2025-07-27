import 'package:flutter/material.dart';
import 'package:tutor/common/theme/app_colors.dart';

class SnackbarHelper {
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      backgroundColor: Colors.green[600],
      icon: Icons.check_circle,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      backgroundColor: AppColors.error,
      icon: Icons.error,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      backgroundColor: Colors.orange[800],
      icon: Icons.warning,
    );
  }

  static void _showSnackbar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    IconData? icon,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null)
            Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: backgroundColor ?? AppColors.primary,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
