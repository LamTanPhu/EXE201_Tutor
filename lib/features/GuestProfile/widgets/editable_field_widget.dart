import 'package:flutter/material.dart';

class EditableFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditing;

  const EditableFieldWidget({
    super.key,
    required this.label,
    required this.controller,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        isEditing
            ? TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            isDense: true,
          ),
        )
            : Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            controller.text.isNotEmpty ? controller.text : 'Not set',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
