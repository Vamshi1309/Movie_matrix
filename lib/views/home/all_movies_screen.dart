import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/widgets/app%20bar/app_bar.dart';
import 'package:movie_matrix/widgets/common/movie_card.dart';
import 'package:movie_matrix/widgets/common/movie_card_grid.dart';

import '../../controllers/theme_controller.dart';

class AllMoviesScreen extends StatelessWidget {

  final String? sectionHeader;

  const AllMoviesScreen({
    Key? key,
    this.sectionHeader
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Get.put(ThemeController()).themeData;

    return Scaffold(
      appBar: CustomAppBar(theme: theme),
      body: MovieCardGrid(
        theme: theme,
        itemCount: 20,
        sectionHeader: sectionHeader ?? "All Movies"
          )
    );
  }
}
