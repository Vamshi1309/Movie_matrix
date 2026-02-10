import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/controllers/movie%20controller/movie_controller.dart';
import 'package:movie_matrix/controllers/theme_controller.dart';
import 'package:movie_matrix/widgets/app%20bar/app_bar.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String? movieName;

  MovieDetailsScreen({required this.movieName});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late ThemeController themeController;
  late MovieController movieController;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    themeController = Get.put(ThemeController());
    movieController = Get.put(MovieController());
    loadData();
  }

  Future<void> loadData() async {
    if (_mounted) {
      await movieController.getMovie(widget.movieName!);
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (movieController.isLoading.value) {
          // If still loading, stop the loading
          movieController.isLoading.value = false;
        }
        return true; // Allow back navigation
      },
      child: Scaffold(
        appBar: CustomAppBar(theme: themeController.themeData),
        body: Obx(() {
          if (movieController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (movieController.error.isNotEmpty) {
            return Center(child: Text(movieController.error.value));
          }

          final movie = movieController.data.value;
          if (movie == null) {
            return Center(child: Text('No movie data available'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      imageBuilder: (context, ImageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image: ImageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.red),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.broken_image),
                      ),
                      fit: BoxFit.fill,
                      height: 400,
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    movie.title,
                    style: themeController.themeData.textTheme.headlineLarge!
                        .copyWith(fontWeight: FontWeight.w900, fontSize: 34),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${movie.releaseYear}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueGrey)),
                      Text(" . ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueGrey)),
                      Text("${movie.duration} min",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueGrey)),
                      Text(" . ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueGrey)),
                      Text("${movie.genre}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueGrey))
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.amber,
                          width: 2,
                        )),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_border_outlined,
                          color: Colors.amber,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          movie.rating.toString() ?? "N/A",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Synopsis",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        movie.description,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 30)
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
