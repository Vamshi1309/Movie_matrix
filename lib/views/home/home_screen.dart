import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/controllers/home%20controller/home_controller.dart';
import 'package:movie_matrix/controllers/top%20rated%20movies%20controller/top_rated_controller.dart';
import 'package:movie_matrix/core/themes/app_spacing.dart';
import 'package:movie_matrix/widgets/app%20bar/app_bar.dart';

import '../../controllers/theme_controller.dart';
import '../../widgets/common/movie_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeMovieController controller = Get.put(HomeMovieController());
  final TopRatedController topRatedController = Get.put(TopRatedController());

  @override
  Widget build(BuildContext context) {
    final theme = Get.put(ThemeController()).themeData;

    return Scaffold(
      appBar: CustomAppBar(theme: theme),
      body: Obx(() {
        if (allCategoriesLoading(controller, topRatedController)) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (allCategoriesFailed(controller, topRatedController)) {
          return Center(
            child: Text(
              "No movies found",
              style: theme.textTheme.titleMedium,
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                buildTrending(theme),
                SizedBox(height: AppSpacing.lg),
                buildTopRated(theme),
                SizedBox(height: AppSpacing.lg),
                buildForYou(theme),
                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      }),
    );
  }

  bool allCategoriesFailed(
    HomeMovieController controller,
    TopRatedController topRatedController,
  ) {
    return controller.errorTrending.value.isNotEmpty &&
        topRatedController.error.value.isNotEmpty &&
        controller.errorForYou.value.isNotEmpty;
  }

  Widget buildTopRated(ThemeData theme) {
    return Obx(() {
      if (topRatedController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (topRatedController.error.value.isNotEmpty) {
        return Text("Top Rated: ${topRatedController.error.value}");
      } else {
        return MovieCard(
          theme: theme,
          sectionHeader: "Top Rated",
          categoryId: 2,
          movies: topRatedController.topRatedMovies.toList(),
        );
      }
    });
  }

  Widget buildTrending(ThemeData theme) {
    return Obx(() {
      if (controller.isLoadingTrending.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.errorTrending.value.isNotEmpty) {
        return Text("Trending: ${controller.errorTrending.value}");
      } else {
        return MovieCard(
          theme: theme,
          sectionHeader: "Trending",
          categoryId: 1,
          movies: controller.trendingMovies.toList(),
        );
      }
    });
  }

  Widget buildForYou(ThemeData theme) {
    return Obx(() {
      if (controller.isLoadingForYou.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.errorForYou.value.isNotEmpty) {
        return Text("For You: ${controller.errorForYou.value}");
      } else {
        return MovieCard(
          theme: theme,
          sectionHeader: "For You",
          categoryId: 3,
          movies: controller.forYouMovies.toList(),
        );
      }
    });
  }

  bool allCategoriesLoading(
    HomeMovieController controller,
    TopRatedController topRatedController,
  ) {
    return controller.isLoadingTrending.value &&
        controller.isLoadingForYou.value &&
        topRatedController.isLoading.value;
  }
}
