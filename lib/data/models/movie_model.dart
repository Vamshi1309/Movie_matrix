class MovieModel {
  final int id;
  final String title;
  final String description;
  final int releaseYear;
  final double rating;
  final String posterUrl;
  final int duration;

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.releaseYear,
    required this.rating,
    required this.posterUrl,
    required this.duration,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      releaseYear: int.tryParse(json['releaseYear'].toString()) ?? 0,
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      posterUrl: json['posterUrl'] ?? '',
      duration: int.tryParse(json['duration'].toString()) ?? 0,
    );
  }
}
