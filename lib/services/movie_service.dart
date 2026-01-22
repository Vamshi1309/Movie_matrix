import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movie_matrix/data/models/movie_model.dart';

class MovieService {
  final Dio dio;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  MovieService()
      : dio = Dio(
          BaseOptions(
              baseUrl: 'http://192.168.0.81:8080/api/movies',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              }),
        ) {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await storage.read(key: 'auth_token');
     
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    }));
  }

  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      final response = await dio.get('/trending');

      // Check if response.data is actually a Map, not a List
      if (response.data is Map<String, dynamic>) {
      }

      final data = response.data;
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
      rethrow;
    }
  }

  Future<List<MovieModel>> getTopRatedMovies() async {
    try {
      final response = await dio.get('/top-rated');

      final data = response.data;
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
      throw Exception(
          e.response?.data['message'] ?? 'Failed to fetch top rated movies');
    }
  }

  Future<List<MovieModel>> getForYouMovies() async {
    try {
      final response = await dio.get('/for-you');

      final data = response.data;
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
      throw Exception(
          e.response?.data['message'] ?? 'Failed to fetch for you movies');
    }
  }
}
