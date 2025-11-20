import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_matrix/core/themes/app_spacing.dart';
import 'package:movie_matrix/core/themes/app_text_styles.dart';
import 'package:movie_matrix/core/themes/app_theme.dart';
import 'package:movie_matrix/providers/theme_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/app_logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image doesn't exist
                  return Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.movie,
                      size: 80,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              Text(
                'Movie Matrix',
                style: theme.textTheme.headlineLarge,
              ),
              SizedBox(height:AppSpacing.md),
              Text(
                'Dive into a personalized universe of\n movies curated just for you.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
