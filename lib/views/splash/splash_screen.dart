import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/auth/auth_state.dart';
import 'package:movie_matrix/core/themes/app_colors.dart';
import 'package:movie_matrix/core/themes/app_spacing.dart';
import 'package:movie_matrix/providers/auth_provider.dart';
import 'package:movie_matrix/views/auth/login_screen.dart';
import 'package:movie_matrix/views/main_screen.dart';

import '../../controllers/theme_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(authProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!mounted) return;

      if (next.isLoading) return;

      if (next.isAuthenticated) {
        Get.offAll(() => MainScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
    });

    final themeController = Get.put(ThemeController(), permanent: true);
    final theme = themeController.themeData;

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
              SizedBox(height: AppSpacing.md),
              Text(
                'Dive into a personalized universe of\n movies curated just for you.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: 150,
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.ratingLow,
                  ),
                  backgroundColor: Colors.grey[300],
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'Loading your watch List..',
                style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600], fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
