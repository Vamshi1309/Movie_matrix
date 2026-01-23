// services/auth_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movie_matrix/core/utils/logger.dart';
import 'package:movie_matrix/data/models/auth_model.dart';

class AuthService {
  final baseUrl = 'http://192.168.0.81:8080/api/auth';
  final storage = const FlutterSecureStorage();
  final appLogger = AppLogger();

  // Configure Dio with proper timeouts
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  Future<AuthModel> register(String email, String password) async {
    try {
      AppLogger.i("Registering email: $email");
      AppLogger.i("URL: $baseUrl/register");

      final response = await dio.post(
        '$baseUrl/register',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      AppLogger.i('Register response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data['message'];
        final token = response.data['data']['token'];

        await storage.write(key: 'auth_token', value: token);
        AppLogger.i('Registration successful, token saved');
        return AuthModel(
          message: message,
          token: token,
        );
      } else {
        final error = response.data['message'] ?? 'Registration failed';
        AppLogger.e('Registration failed: $error');
        throw Exception(error);
      }
    } on DioException catch (e) {
      AppLogger.e('Registration DioException: ${e.type}');
      AppLogger.e('Message: ${e.message}');

      // FIX: Handle both Map and String error responses
      String errorMessage = 'Registration failed';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Server is not responding. Please check if the server is running.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'Cannot connect to server. Please check your network connection.';
      } else if (e.response != null) {
        // FIX: Check if response.data is Map or String
        AppLogger.e('Response data type: ${e.response!.data.runtimeType}');
        AppLogger.e('Response data: ${e.response!.data}');

        if (e.response!.data is Map<String, dynamic>) {
          errorMessage = e.response!.data['message'] ?? 'Registration failed';
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
        }

        AppLogger.e('Extracted error message: $errorMessage');
      } else {
        errorMessage = 'Network error occurred';
      }

      throw Exception(errorMessage);
    } catch (e) {
      AppLogger.e('Registration error: $e');
      rethrow;
    }
  }

  Future<AuthModel> login(String email, String password) async {
    try {
      AppLogger.i("Login email: $email");
      AppLogger.i("URL: $baseUrl/login");

      final response = await dio.post(
        '$baseUrl/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      AppLogger.i('Login response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final message = response.data['message'];
        final token = response.data['data']['token'];
        await storage.write(key: 'auth_token', value: token);
        AppLogger.i('Login successful, token saved');
        return AuthModel(
          message: message,
          token: token,
        );
      } else {
        final error = response.data['message'] ?? 'Login failed';
        AppLogger.e('Login failed: $error');
        throw Exception(error);
      }
    } on DioException catch (e) {
      AppLogger.e('Login DioException: ${e.type}');
      AppLogger.e('Message: ${e.message}');

      // FIX: Handle both Map and String error responses
      String errorMessage = 'Login failed';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Server is not responding. Please check if the server is running.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'Cannot connect to server. Please check your network connection.';
      } else if (e.response != null) {
        // FIX: Check if response.data is Map or String
        AppLogger.e('Response data type: ${e.response!.data.runtimeType}');
        AppLogger.e('Response data: ${e.response!.data}');

        if (e.response!.data is Map<String, dynamic>) {
          errorMessage = e.response!.data['message'] ?? 'Login failed';
        } else if (e.response!.data is String) {
          errorMessage = e.response!.data;
        }

        AppLogger.e('Extracted error message: $errorMessage');
      } else {
        errorMessage = 'Network error occurred';
      }

      throw Exception(errorMessage);
    } catch (e) {
      AppLogger.e('Login error: $e');
      rethrow;
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    AppLogger.i("is Authenticated check: ${token != null}");
    return token != null;
  }

  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
    AppLogger.i('👋 User logged out, token deleted');
  }
}
