import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCommentSectionWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  const AddCommentSectionWidget({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        const Text('Thêm bình luận',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Viết suy nghĩ của bạn...',
            filled: true,
            fillColor: const Color(0xFFF0F0F0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.image), onPressed: () {}),
            IconButton(icon: const Icon(Icons.gif_box), onPressed: () {}),
            IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: isSubmitting ? null : onSubmit,
              icon: isSubmitting
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.send),
              label: const Text("Đăng bình luận"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}