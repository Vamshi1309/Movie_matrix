import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/views/home/all_movies_screen.dart';
import 'package:movie_matrix/widgets/common/build_movie_card.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_spacing.dart';

class MovieCard extends StatelessWidget {
  final ThemeData theme;
  final String sectionHeader;
  final int categoryId;
  final List<MovieModel> movies;

  const MovieCard({
    super.key,
    required this.theme,
    required this.categoryId,
    required this.sectionHeader,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    final displayMovies = movies.length > 10 ? movies.sublist(0, 10) : movies;

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
                    categoryId: categoryId,
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
              itemCount: displayMovies.length + 1,
              itemBuilder: (context, index) {
                if (index == displayMovies.length) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => AllMoviesScreen(
                            sectionHeader: sectionHeader,
                            categoryId: categoryId,
                          ));
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(left: 8.0),
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
                }

                final movie = displayMovies[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: BuildMovieCard(
                    theme: theme,
                    imgUrl: 'http://10.0.2.2:8080${movie.posterUrl}',
                    title: movie.title,
                    rating: movie.rating,
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
