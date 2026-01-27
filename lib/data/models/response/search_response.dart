import 'package:movie_matrix/data/models/search_data.dart';

class SearchResponse {
  final bool success;
  final String message;
  final SearchData data;

  SearchResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      success: json['success'],
      message: json['message'],
      data: SearchData.fromJson(json['data']),
    );
  }
}
