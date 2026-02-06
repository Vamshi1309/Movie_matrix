import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/core/utils/api_config.dart';
import 'package:movie_matrix/core/utils/logger.dart';
import 'package:movie_matrix/services/storage_service.dart';
import 'package:movie_matrix/views/auth/login_screen.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: '${ApiConfig.baseUrl}/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          AppLogger.i("🔵 Interceptor triggered");
          final token = await StorageService.getToken();
          AppLogger.i("token : $token");
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            AppLogger.i("token : $token");
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          final response = error.response;

          if (response != null && response.statusCode == 401) {
            await StorageService.clearToken();

            final msg = response.data['message'] ?? 'Unauthorized';
            if (Get.context != null) {
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: Colors.red),
              );
            }

            Get.offAll(() => LoginScreen());

            return handler.reject(error);
          }

          return handler.next(error);
        },
      ),
    );
}
