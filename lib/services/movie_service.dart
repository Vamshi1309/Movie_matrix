import 'package:dio/dio.dart';
import 'package:movie_matrix/core/network/api_service.dart';
import 'package:movie_matrix/core/utils/logger.dart';
import 'package:movie_matrix/data/models/movie_model.dart';

class MovieService {
  final Dio dio = ApiService.dio;

  final String baseUrl = "/movies";

  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      AppLogger.i('📡 Fetching trending movies...');
      final response = await dio.get('$baseUrl/trending');
      AppLogger.i('✅ Trending movies fetched successfully');

      final data = response.data["data"];

      if (data is List) {
        return data.map((e) {
          if (e is Map<String, dynamic>) {
            return MovieModel.fromJson(e);
          } else {
            throw Exception('Invalid movie data format');
          }
        }).toList();
      } else {
        throw Exception('Unexpected response format: ${data.runtimeType}');
      }
    } on DioException catch (e) {
      AppLogger.e('❌ Trending movies error: ${e.type}');
      AppLogger.e('Response data type: ${e.response?.data.runtimeType}');
      AppLogger.e('Response data: ${e.response?.data}');
      // FIX: Handle both Map and String error responses
      String errorMessage = 'Failed to fetch trending movies';

      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;
          AppLogger.e('Error from Map: $errorMessage');
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
          AppLogger.e('Error from String: $errorMessage');
        }
      }

      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> getNowPlayingMovies({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      AppLogger.i('📡 Fetching now playing movies...');
      final response = await dio.get('$baseUrl/now-playing',
          queryParameters: {'page': page, 'limit': limit});
      AppLogger.i('✅ Now playing movies fetched successfully');

      final data = response.data["data"]["content"];
      if (data is List) {
        final movies = data.map((e) {
          if (e is Map<String, dynamic>) {
            return MovieModel.fromJson(e);
          } else {
            throw Exception('Invalid movie data format');
          }
        }).toList();

        return {
          'movies': movies,
          'totalPages': response.data["data"]['totalPages'],
          'hasNext': response.data["data"]['last'] == false,
        };
      } else {
        throw Exception('Unexpected response format');
      }
    } on DioException catch (e) {
      AppLogger.e('❌ Now playing movies error: ${e.type}');
      AppLogger.e('Response data type: ${e.response?.data.runtimeType}');
      AppLogger.e('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch now playing movies';

      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;
          AppLogger.e('Error from Map: $errorMessage');
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
          AppLogger.e('Error from String: $errorMessage');
        }
      }

      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> getPopularMovies({
    int page = 0,
    int limit = 5,
  }) async {
    try {
      AppLogger.i('📡 Fetching popular movies...');
      final response = await dio.get('$baseUrl/popular',
          queryParameters: {'page': page, 'limit': limit});
      AppLogger.i('✅ Popular movies fetched successfully');

      final data = response.data["data"]["content"];
      if (data is List) {
        final movies = data.map((e) {
          if (e is Map<String, dynamic>) {
            return MovieModel.fromJson(e);
          } else {
            throw Exception('Invalid movie data format');
          }
        }).toList();

        return {
          'movies': movies,
          'totalPages': response.data["data"]['totalPages'],
          'hasNext': response.data["data"]['last'] == false,
        };
      } else {
        throw Exception('Unexpected response format');
      }
    } on DioException catch (e) {
      AppLogger.e('❌ Popular movies error: ${e.type}');
      AppLogger.e('Response data type: ${e.response?.data.runtimeType}');
      AppLogger.e('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch popular movies';

      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;
          AppLogger.e('Error from Map: $errorMessage');
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
          AppLogger.e('Error from String: $errorMessage');
        }
      }

      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> getTopRatedMovies({
    int page = 0,
    int limit = 5,
  }) async {
    try {
      AppLogger.i('📡 Fetching top rated movies...');
      final response = await dio.get('$baseUrl/top-rated',
          queryParameters: {'page': page, 'limit': limit});
      AppLogger.i('✅ Top rated movies fetched successfully');

      final data = response.data["data"]["content"];
      if (data is List) {
        final movies = data.map((e) {
          if (e is Map<String, dynamic>) {
            return MovieModel.fromJson(e);
          } else {
            throw Exception('Invalid movie data format');
          }
        }).toList();

        return {
          'movies': movies,
          'totalPages': response.data["data"]['totalPages'],
          'hasNext': response.data["data"]['last'] == false,
        };
      } else {
        throw Exception('Unexpected response format');
      }
    } on DioException catch (e) {
      AppLogger.e('❌ Top rated movies error: ${e.type}');
      AppLogger.e('Response data type: ${e.response?.data.runtimeType}');
      AppLogger.e('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch top rated movies';

      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;
          AppLogger.e('Error from Map: $errorMessage');
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
          AppLogger.e('Error from String: $errorMessage');
        }
      }

      throw Exception(errorMessage);
    }
  }

  Future<List<MovieModel>> getForYouMovies() async {
    try {
      AppLogger.i('📡 Fetching for you movies...');
      final response = await dio.get('$baseUrl/for-you');
      AppLogger.i('✅ For you movies fetched successfully');

      final data = response.data["data"];
      if (data is List) {
        return data.map((e) {
          if (e is Map<String, dynamic>) {
            return MovieModel.fromJson(e);
          } else {
            throw Exception('Invalid movie data format');
          }
        }).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } on DioException catch (e) {
      AppLogger.e('❌ For you movies error: ${e.type}');
      AppLogger.e('Response data type: ${e.response?.data.runtimeType}');
      AppLogger.e('Response data: ${e.response?.data}');

      String errorMessage = 'Failed to fetch for you movies';

      if (e.response?.data != null) {
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;
          AppLogger.e('Error from Map: $errorMessage');
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
          AppLogger.e('Error from String: $errorMessage');
        }
      }

      throw Exception(errorMessage);
    }
  }
}
