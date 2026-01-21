import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:movie_matrix/widgets/app%20bar/app_bar.dart';

import '../../controllers/theme_controller.dart';
import 'movies_list_screen.dart';

class BrowseScreen extends StatelessWidget {
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
                  child: TabBarView(children: [
                // Popular Tab
                MovieListScreen(
                  theme: theme,
                  imageUrl:
                      "https://m.media-amazon.com/images/M/MV5BNDJiZDgzZjctYmFiYy00MjZhLTllNmUtODViNDQ2ODMwMDM4XkEyXkFqcGdeQXVyMTUzOTcyODA5._V1_FMjpg_UX1000_.jpg",
                  movieName: "Varanasi: City of Light",
                  rating: 8.7,
                  year: 2024,
                  genre: "Mystery/Thriller",
                  duration: "2h 18m",
                  description:
                      "A detective uncovers ancient secrets in the spiritual capital of India while investigating a series of mysterious disappearances.",
                ),

                // Now Playing Tab
                MovieListScreen(
                  theme: theme,
                  imageUrl:
                      "https://m.media-amazon.com/images/M/MV5BZGQ2ODNiNzktOWE3Ny00M2RlLWE4YTgtNzliMzEyNzU1YzU0XkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_FMjpg_UX1000_.jpg",
                  movieName: "AA22: Code Red",
                  rating: 7.9,
                  year: 2023,
                  genre: "Action/Sci-Fi",
                  duration: "2h 05m",
                  description:
                      "An elite agent must stop a rogue AI system from triggering global chaos in this high-tech espionage thriller.",
                ),

                // Top Rated Tab
                MovieListScreen(
                  theme: theme,
                  imageUrl:
                      "https://m.media-amazon.com/images/M/MV5BMTY5ODk1NzUyMl5BMl5BanBnXkFtZTgwMjUyNzEyMTE@._V1_FMjpg_UX1000_.jpg",
                  movieName: "Dragon's Legacy",
                  rating: 9.2,
                  year: 2024,
                  genre: "Fantasy/Adventure",
                  duration: "2h 45m",
                  description:
                      "In a mythical kingdom, a young warrior must embrace her dragon-riding heritage to save her people from dark forces.",
                ),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
