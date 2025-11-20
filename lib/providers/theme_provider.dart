// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_matrix/core/themes/app_theme.dart';

enum AppThemeMode { light, dark, system }

final themeModeProvider = StateProvider<AppThemeMode>((ref) => AppThemeMode.light);

final appThemeProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  
  // In a real app, you'd check system theme here
  return themeMode == AppThemeMode.dark 
      ? AppTheme.darkTheme 
      : AppTheme.lightTheme;
});