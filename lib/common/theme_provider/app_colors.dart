import 'package:flutter/material.dart';

class LightColors {
  static const Color primary = Color(0xFF007AFF); // Trusted, Apple-like blue
  static const Color white = Color.fromARGB(255, 255, 255, 255); // Pure white
  static const Color background = Color.fromARGB(255, 227, 227, 227); // Very light gray
  static const Color accent = Color.fromARGB(255, 229, 229, 229); // Light gray for subtle highlights
  static const Color textPrimary = Color.fromARGB(255, 59, 59, 59); // Dark gray (for primary text)
  static const Color textSecondary = Color.fromARGB(255, 98, 98, 98); // Medium gray (for secondary text)
}

class DarkColors {
  static const Color primary = Color(0xFF007AFF); // Same electric blue for dark mode
  static const Color black = Color.fromARGB(255, 0, 0, 0); // Dark gray (almost black, but comfortable)
  static const Color background = Color(0xFF2B2B2B); // Slightly lighter dark gray
  static const Color accent = Color.fromARGB(255, 71, 71, 71); // Mid-gray for accents or subtle highlights
  static const Color textPrimary =
      Color.fromARGB(255, 206, 206, 206); // Light gray (off-white for readability)
  static const Color textSecondary = Color.fromARGB(255, 169, 169, 169); // Softer gray for secondary text
}
