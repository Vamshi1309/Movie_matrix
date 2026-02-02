import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/controllers/home%20controller/home_controller.dart';
import 'package:movie_matrix/controllers/top%20rated%20movies%20controller/top_rated_controller.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/widgets/app%20bar/app_bar.dart';
import 'package:movie_matrix/widgets/common/movie_card_grid.dart';

import '../../controllers/theme_controller.dart';

class AllMoviesScreen extends StatelessWidget {
  final String? sectionHeader;
  final int categoryId;

  AllMoviesScreen({Key? key, this.sectionHeader, required this.categoryId}) : super(key: key);

  final HomeMovieController controller = Get.put(HomeMovieController());
  final TopRatedController topRatedController = Get.put(TopRatedController());

  @override
  Widget build(BuildContext context) {
    final theme = Get.put(ThemeController()).themeData;

    return Scaffold(
        appBar: CustomAppBar(theme: theme),
        body: MovieCardGrid(
            theme: theme,
            categoryId: categoryId,
            movies: _getMoviesByCategory(categoryId),
            sectionHeader: sectionHeader ?? "All Movies"
          )
        );
  }

  List<MovieModel> _getMoviesByCategory(int categoryId){
    switch(categoryId){
      case 1:
        return controller.trendingMovies.toList();
      case 2:
        return topRatedController.topRatedMovies.toList();
      case 3:
        return controller.forYouMovies.toList();
      default:
        return [];
    }
  }
}
