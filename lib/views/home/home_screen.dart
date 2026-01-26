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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Obx(() {
                  if (controller.isLoadingTrending.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.errorTrending.value.isNotEmpty) {
                    return Center(child: Text(controller.errorTrending.value));
                  } else {
                    return MovieCard(
                      theme: theme,
                      sectionHeader: "Trending",
                      categoryId: 1,
                      movies: controller.trendingMovies.toList(),
                    );
                  }
                }),
                SizedBox(height: AppSpacing.lg),
                Obx(() {
                  if (topRatedController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (topRatedController.error.value.isNotEmpty) {
                    return Text(topRatedController.error.value);
                  } else {
                    return MovieCard(
                      theme: theme,
                      sectionHeader: "Top Rated",
                      categoryId: 2,
                      movies: topRatedController.topRatedMovies.toList(),
                    );
                  }
                }),

                SizedBox(height: AppSpacing.lg),
                Obx(() {
                  if (controller.isLoadingForYou.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.errorForYou.value.isNotEmpty) {
                    return Text(controller.errorForYou.value);
                  } else {
                    return MovieCard(
                      theme: theme,
                      sectionHeader: "For You",
                      categoryId: 3,
                      movies: controller.forYouMovies.toList(),
                    );
                  }
                }),

                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ));
  }
}
