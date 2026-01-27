import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movie_matrix/core/utils/api_config.dart';
import 'package:movie_matrix/core/utils/logger.dart';
import 'package:movie_matrix/data/models/movie_model.dart';
import 'package:movie_matrix/data/models/response/api_response.dart';
import 'package:movie_matrix/data/models/response/search_response.dart';

class SearchService {
  static final String baseUrl = ApiConfig.baseUrl;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${baseUrl}/api/search',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SearchService() {
    // Add interceptor to attach JWT token
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          AppLogger.i('🔑 JWT token attached to request');
        } else {
          AppLogger.w('⚠️ No JWT token available');
        }
        handler.next(options);
      }),
    );
  }

  Future<SearchResponse> getSearchData() async {
    try {
      AppLogger.i('📡 Fetching search data...');
      final response = await _dio.get(
        '/data',
        queryParameters: {'userId': ApiConfig.userId},
      );
      AppLogger.i('✅ Search data fetched successfully');

      return SearchResponse.fromJson(response.data);
    } on DioException catch (e) {
      AppLogger.e('❌ Search data error: ${e.type}');
      AppLogger.e('Response type: ${e.response?.data.runtimeType}');
      AppLogger.e('Response data: ${e.response?.data}');
      String errorMessage = 'Failed to load search data';
      if (e.response?.data != null && e.response!.data is Map) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      throw Exception(errorMessage);
    }
  }

  /// Get movie suggestions (while typing - min 2 chars)
  Future<ApiResponse<List<MovieModel>>> getSuggestions(String query) async {
    if (query.trim().isEmpty) {
      return ApiResponse(success: true, message: '', data: []);
    }

    try {
      AppLogger.i('📡 Fetching suggestions for "$query"...');
      final response = await _dio.get(
        '/suggestions',
        queryParameters: {'query': query},
      );
      AppLogger.i('✅ Suggestions fetched successfully');

      return ApiResponse.fromJson(
        response.data,
        (json) =>
            (json as List).map((movie) => MovieModel.fromJson(movie)).toList(),
      );
    } on DioException catch (e) {
      AppLogger.e('❌ Suggestions error: ${e.type}');
      AppLogger.e('Response type: ${e.response?.data.runtimeType}');
      AppLogger.e('Response data: ${e.response?.data}');
      String errorMessage = 'Failed to get suggestions';
      if (e.response?.data != null && e.response!.data is Map) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      throw Exception(errorMessage);
    }
  }

  /// Get movie by exact title (when user selects/searches)
  Future<ApiResponse<MovieModel>?> getMovieByTitle(String title) async {
    try {
      AppLogger.i('📡 Fetching movie details for "$title"...');
      final response = await _dio.get(
        '/movie',
        queryParameters: {'title': title, 'userId': ApiConfig.userId},
      );
      AppLogger.i('✅ Movie "$title" fetched successfully');

      return ApiResponse.fromJson(
        response.data,
        (json) => MovieModel.fromJson(json),
      );
    } on DioException catch (e) {
      AppLogger.e('❌ Movie fetch error: ${e.type}');
      AppLogger.e('Response type: ${e.response?.data.runtimeType}');
      AppLogger.e('Response data: ${e.response?.data}');

      if (e.response?.statusCode == 404) return null;

      String errorMessage = 'Failed to get movie';
      if (e.response?.data != null && e.response!.data is Map) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      throw Exception(errorMessage);
    }
  }
}
