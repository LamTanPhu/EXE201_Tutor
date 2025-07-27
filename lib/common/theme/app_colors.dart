import 'package:flutter/material.dart';

class AppColors {
// PRIMARY SYSTEM
  static const Color primary = Color(0xFF007BFF); // Blue
  static const Color lightPrimary = Color(0xFF90CAF9); // Light Blue
  static const Color darkPrimary = Color(0xFF0056B3); // Darker Blue

  // SECONDARY
  static const Color secondary = Color(0xFF6C757D); // Cool Grey
  static const Color lightSecondary = Color(0xFFB0BEC5); 
  static const Color darkSecondary = Color(0xFF495057); 

  // ACCENT / WARNING / SUCCESS / ERROR / INFO
  static const Color accent = Color(0xFFFFA000); // Amber
  static const Color warning = Color(0xFFFFC107); // Yellow
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color error = Color(0xFFD32F2F);   // Red
  static const Color info = Color(0xFF17A2B8);    // Cyan / Teal

  // NEUTRAL / BACKGROUND / CARD
  static const Color background = Color(0xFFF5F5F5); 
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF); 
  static const Color divider = Color(0xFFBDBDBD);

  // TEXT
  static const Color text = Color(0xFF212121); 
  static const Color subText = Color(0xFF757575); 
  static const Color disabled = Color(0xFFBDBDBD);

  // WHITE / BLACK
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // GRADIENT BACKGROUNDS
  static const Color backgroundGradientStart = darkPrimary; // Light blueish
  static const Color backgroundGradientEnd = lightPrimary;

  // Custom Gradient: Blue → Green
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundGradientStart, backgroundGradientEnd],
  );

  // Custom Gradient: Purple → Blue
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
  );
}
