import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:movie_matrix/core/utils/api_config.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/views/movie/movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  final ThemeData theme;
  final List<MovieModel> movies;
  final bool isLoading;
  final String error;
  final VoidCallback? onLoadMore;

  MovieListScreen({
    super.key,
    required this.theme,
    required this.movies,
    required this.isLoading,
    required this.error,
    this.onLoadMore,
  });

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      widget.onLoadMore?.call();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.movies.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (widget.error.isNotEmpty && widget.movies.isEmpty) {
      final cleanError = widget.error.replaceFirst('Exception: ', '');
      return Center(
          child: Text(cleanError, style: widget.theme.textTheme.bodyMedium));
    }

    if (widget.movies.isEmpty) {
      return Center(
          child: Text("No movies available",
              style: widget.theme.textTheme.bodyMedium));
    }

    return Container(
        width: double.infinity,
        child: ListView.builder(
            controller: _scrollController,
            itemCount: widget.movies.length + (widget.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == widget.movies.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Column(
                children: [
                  SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      Get.to(MovieDetailsScreen(
                          movieName: widget.movies[index].title));
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
                                imageUrl: ApiConfig.getFullImageUrl(
                                    widget.movies[index].posterUrl),
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
                                          widget.movies[index].title,
                                          style: widget
                                              .theme.textTheme.titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                        widget.movies[index].rating.toString(),
                                        style: widget
                                            .theme.textTheme.titleMedium
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
                                    "${widget.movies[index].releaseYear} · ${widget.movies[index].genre} · ${widget.movies[index].duration} mins",
                                    style: widget.theme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),

                                  SizedBox(height: 10),

                                  // Description
                                  Text(
                                    widget.movies[index].description,
                                    style: widget.theme.textTheme.bodyMedium
                                        ?.copyWith(
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
