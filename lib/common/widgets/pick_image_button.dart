import 'package:flutter/material.dart';

class PickImageButton extends StatelessWidget {
  //an action without requiring any input or expecting outputs
  //=> using Voidcallback
  final VoidCallback onPickImages;
  const PickImageButton({super.key, required this.onPickImages});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPickImages,
      label: const Text('Upload Image'),
      icon: const Icon(Icons.image),
    );
  }
}
