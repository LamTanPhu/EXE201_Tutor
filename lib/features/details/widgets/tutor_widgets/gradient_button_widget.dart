import 'package:flutter/material.dart';

class GradientButtonWidget extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const GradientButtonWidget({super.key, required this.text, required this.onTap});

  @override
  _GradientButtonWidgetState createState() => _GradientButtonWidgetState();
}

class _GradientButtonWidgetState extends State<GradientButtonWidget> with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isPressed
                ? [Colors.blue[600]!, Colors.blueAccent[700]!]
                : [Colors.blue, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(_isPressed ? 0.2 : 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.transparent,
          onTap: () {}, // Handled by GestureDetector
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}