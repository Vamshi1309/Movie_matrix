// lib/core/themes/app_colors.dart
import 'dart:ui';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2563EB); // Blue from buttons
  static const Color secondary = Color(0xFF7C3AED); // Purple accent
  static const Color accent = Color(0xFF06B6D4); // Cyan for highlights
  
  // Neutral Colors
  static const Color background = Color(0xFFF8FAFC); // Light gray background
  static const Color surface = Color(0xFFFFFFFF); // White cards/surface
  static const Color onSurface = Color(0xFF1F2937); // Dark text
  static const Color onSurfaceVariant = Color(0xFF6B7280); // Gray text
  
  // Semantic Colors
  static const Color error = Color(0xFFDC2626); // Red for errors
  static const Color success = Color(0xFF16A34A); // Green for ratings
  static const Color warning = Color(0xFFD97706); // Amber
  
  // Rating Colors
  static const Color ratingHigh = Color(0xFF16A34A); // 4.0+ ratings
  static const Color ratingMedium = Color(0xFFD97706); // 3.0-3.9 ratings
  static const Color ratingLow = Color(0xFFDC2626); // Below 3.0
}