class SearchData {
  final List<String> recentSearches;
  final List<String> popularMovies;

  SearchData({
    required this.recentSearches,
    required this.popularMovies,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
      recentSearches:
          List<String>.from(json['recentSearches'] ?? []),
      popularMovies:
          List<String>.from(json['popularMovies'] ?? []),
    );
  }
}
