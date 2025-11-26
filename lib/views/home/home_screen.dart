import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_matrix/core/themes/app_colors.dart';
import 'package:movie_matrix/core/themes/app_spacing.dart';
import 'package:movie_matrix/providers/theme_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);

    return Scaffold(
      appBar: _buildAppBar(theme),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trending",
                  style: theme.textTheme.titleMedium,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to see all trending movies
                  },
                  child: Text(
                    "see all",
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: AppColors.ratingLow),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 11,
                itemBuilder: (context, index) {
                  if (index <= 10) {
                    final movieData = {
                      'imgUrl':
                          'https://via.placeholder.com/150x220.png?text=Movie+${index + 1}',
                      'title': 'Movie ${index + 1}',
                      'rating': (5.0 + index % 5).toDouble(),
                    };

                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: _buildMovieCard(
                        theme: theme,
                        imgUrl: movieData['imgUrl'] as String,
                        title: movieData['title'] as String,
                        rating: movieData['rating'] as double,
                      ),
                    );
                  }else{
                    return SizedBox(width: 115, child: Icon(Icons.navigate_next));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(
      {ThemeData? theme, String? imgUrl, String? title, double? rating}) {
    return SizedBox(
      width: 115, // Fixed width for consistent sizing
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Movie Poster Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imgUrl!,
                  width: double.infinity,
                  height: 120, // Reduced height to fit content
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.grey),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.md),

              Text(
                title ?? "No Title",
                style: theme?.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Rating Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: theme?.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      toolbarHeight: 100,
      titleSpacing: 0,
      backgroundColor: theme.colorScheme.background,
      elevation: 0,
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
                    size: 30,
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
                  "Tonight's picks for you..",
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
}
