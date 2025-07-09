import 'package:flutter/material.dart';

class LoadingOverlayWidget extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlayWidget({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF4A90E2),
        strokeWidth: 6,
      ),
    )
        : const SizedBox.shrink();
  }
}