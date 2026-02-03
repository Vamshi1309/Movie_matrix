import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:movie_matrix/core/utils/api_config.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/views/movie/movie_detail_screen.dart';

class MovieListScreen extends StatelessWidget {
  final ThemeData theme;
  final List<MovieModel> movies;
  final bool isLoading;
  final String error;

  MovieListScreen(
      {super.key,
      required this.theme,
      required this.movies,
      required this.isLoading,
      required this.error});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      final cleanError = error.replaceFirst('Exception: ', '');
      return Center(child: Text(cleanError, style: theme.textTheme.bodyMedium));
    }

    if (movies.isEmpty) {
      return Center(
          child:
              Text("No movies available", style: theme.textTheme.bodyMedium));
    }

    return Container(
        width: double.infinity,
        child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(height: 18),
                  GestureDetector(
                    onTap: (){
                      Get.to(MovieDetailsScreen(movieName: movies[index].title));
                    },
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Movie Poster
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl:
                                    ApiConfig.getFullImageUrl(movies[index].posterUrl),
                                height: 110,
                                // Adjusted height
                                width: 80,
                                // Adjusted width for better aspect ratio
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return Container(
                                    height: 110, // Adjusted height
                                    width: 80,
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  );
                                },
                                errorWidget: (context, url, error) => Container(
                                  height: 110, // Adjusted height
                                  width: 80,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.error, color: Colors.grey),
                                ),
                              ),
                            ),
                    
                            SizedBox(width: 22),
                    
                            // Movie Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Title and Rating in same row
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          movies[index].title,
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: 16),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        movies[index].rating.toString(),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 16),
                                      ),
                                    ],
                                  ),
                    
                                  SizedBox(height: 8),
                    
                                  // Year, Genre, Duration
                                  Text(
                                    "${movies[index].releaseYear} · ${movies[index].genre} · ${movies[index].duration} mins",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                    
                                  SizedBox(height: 10),
                    
                                  // Description
                                  Text(
                                    movies[index].description,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[700],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              );
            }));
  }
}
