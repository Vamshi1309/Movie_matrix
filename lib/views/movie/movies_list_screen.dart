import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieListScreen extends StatelessWidget {
  final ThemeData theme;
  final String imageUrl;
  final String movieName;
  final double rating;
  final int year;
  final String genre;
  final String duration;
  final String description;

  MovieListScreen(
      {super.key,
      required this.theme,
      required this.imageUrl,
      required this.movieName,
      required this.rating,
      required this.year,
      required this.genre,
      required this.duration,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(height: 18),
                  Card(
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
                              imageUrl: imageUrl,
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
                                        movieName,
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
                                      rating.toString(),
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
                                  "${year} · ${genre} · ${duration}",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),

                                SizedBox(height: 10),

                                // Description
                                Text(
                                  description,
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
                  SizedBox(height: 15),
                ],
              );
            }));
  }
}
