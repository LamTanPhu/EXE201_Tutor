import 'package:flutter/material.dart';

class AddCommentSheetWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  const AddCommentSheetWidget({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0, right: 16.0, top: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Add Comment', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 16.0),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Comment',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Color(0xFFF5F5F5),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: isSubmitting ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: isSubmitting ? Colors.grey : Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            child: isSubmitting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                : const Text('Submit Comment'),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
