import 'package:flutter/material.dart';

import '../../core/themes/app_spacing.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeData theme;
  final bool isLoginScreen;

  const CustomAppBar(
      {super.key, required this.theme, this.isLoginScreen = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      titleSpacing: 0,
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/app_logo.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.movie,
                    size: 40,
                    color: theme.colorScheme.surface,
                  ),
                );
              },
            ),
            SizedBox(width: AppSpacing.xs),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Movie Matrix',
                  style: theme.textTheme.titleLarge,
                ),
                Text(
                  isLoginScreen
                      ? "Login to explore movies"
                      : "Explore Tollywood Movies..",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
