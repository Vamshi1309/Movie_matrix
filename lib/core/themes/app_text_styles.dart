// lib/core/themes/app_text_styles.dart

import 'package:flutter/material.dart';
import 'package:movie_matrix/core/themes/app_colors.dart';

class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.onSurface,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.onSurface,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.onSurface,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.onSurface,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.onSurface,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.onSurfaceVariant,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.onSurfaceVariant,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.primary,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.4,
    color: AppColors.primary,
  );
}