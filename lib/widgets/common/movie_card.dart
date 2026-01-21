import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/views/home/all_movies_screen.dart';
import 'package:movie_matrix/widgets/common/build_movie_card.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_spacing.dart';

class MovieCard extends StatelessWidget {
  final ThemeData theme;
  final String sectionHeader;
  final int itemCount;

  const MovieCard({
    super.key,
    required this.theme,
    required this.itemCount,
    required this.sectionHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),

          // --- Title Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionHeader,
                style: theme.textTheme.titleMedium,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(AllMoviesScreen(
                    sectionHeader: sectionHeader,
                  ));
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

          // --- Movies List ---
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index < 10) {
                  final movieData = {
                    'imgUrl': "https://picsum.photos/200/300",
                    'title': 'Movie ${index + 1}',
                    'rating': (5.0 + index % 5).toDouble(),
                  };

                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: BuildMovieCard(
                      theme: theme,
                      imgUrl: movieData['imgUrl'] as String,
                      title: movieData['title'] as String,
                      rating: movieData['rating'] as double,
                    ),
                  );
                }

                // --- Final Arrow Button ---
                return GestureDetector(
                  onTap: () {
                    Get.to(AllMoviesScreen(
                      sectionHeader: sectionHeader,
                    ));
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
