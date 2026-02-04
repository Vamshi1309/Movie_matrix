import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:movie_matrix/controllers/browse%20controller/browse_controller.dart';
import 'package:movie_matrix/controllers/top%20rated%20movies%20controller/top_rated_controller.dart';
import 'package:movie_matrix/widgets/app%20bar/app_bar.dart';

import '../../controllers/theme_controller.dart';
import 'movies_list_screen.dart';

class BrowseScreen extends StatelessWidget {
  final BrowseMovieController controller = Get.put(BrowseMovieController());
  final TopRatedController topRatedController = Get.put(TopRatedController());

  @override
  Widget build(BuildContext context) {
    final theme = Get.put(ThemeController()).themeData;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: CustomAppBar(theme: theme),
          body: Column(
            children: [
              Container(
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.red,
                  indicatorColor: Colors.red,
                  dividerColor: Colors.transparent,
                  labelPadding: EdgeInsets.zero,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Popular'),
                    Tab(text: 'Now Playing'),
                    Tab(text: 'Top Rated'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Popular Tab
                    Obx(() {
                      return MovieListScreen(
                        theme: theme,
                        movies: controller.popularMovies,
                        isLoading: controller.isLoadingPopular.value,
                        error: controller.errorPopular.value,
                        onLoadMore: () =>
                            controller.fetchPopularMovies(loadMore: true),
                      );
                    }),

                    // Now Playing Tab
                    Obx(() {
                      return MovieListScreen(
                        theme: theme,
                        movies: controller.nowPlayingMovies,
                        isLoading: controller.isLoadingNowPlaying.value,
                        error: controller.errorNowPlaying.value,
                        onLoadMore: () =>
                            controller.fetchNowPlayingMovies(loadMore: true),
                      );
                    }),

                    // Top Rated Tab
                    Obx(() {
                      return MovieListScreen(
                        theme: theme,
                        movies: topRatedController.topRatedMovies,
                        isLoading: topRatedController.isLoading.value,
                        error: topRatedController.error.value,
                        onLoadMore: () => topRatedController
                            .fetchTopRatedMovies(loadMore: true),
                      );
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
