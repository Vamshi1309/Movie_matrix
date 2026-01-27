import 'package:flutter/material.dart';
import 'package:movie_matrix/core/utils/api_config.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/widgets/common/build_movie_card.dart';
import '../../../core/themes/app_spacing.dart';

class MovieCardGrid extends StatelessWidget {
  final ThemeData theme;
  final String sectionHeader;
  final int categoryId;
  final List<MovieModel> movies;

  const MovieCardGrid({
    super.key,
    required this.theme,
    required this.categoryId,
    required this.movies,
    required this.sectionHeader,
  });

  @override
  Widget build(BuildContext context) {
    return movies.length == 0
        ? Center(child: Text("No movies available", style: theme.textTheme.bodyMedium))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // --- Movies List ---
                  GridView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.85),
                    children: List.generate(movies.length, (index) {
                      final movieData = movies[index];

                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: BuildMovieCard(
                          theme: theme,
                          imgUrl: ApiConfig.getFullImageUrl(movieData.posterUrl),
                          title: movieData.title,
                          rating: movieData.rating,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
  }
}
