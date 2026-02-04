import 'package:dio/dio.dart';
import 'package:movie_matrix/core/network/api_service.dart';
import 'package:movie_matrix/core/utils/logger.dart';
import 'package:movie_matrix/data/models/password_reset_models.dart';

class PasswordResetService {
  final String baseUrl = '/auth/reset-password';

  Future<PasswordResetResponse> sendOtp(String email) async {
    try {
      AppLogger.i("📧 Sending OTP to: $email");
      AppLogger.i("URL: $baseUrl/send-otp");

      final response = await ApiService.dio.post(
        '$baseUrl/send-otp',
        data: ForgotPasswordRequest(email: email).toJson(),
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      AppLogger.i('Send OTP response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return PasswordResetResponse.fromJson(response.data);
      } else {
        final error = response.data['message'] ?? 'Failed to send OTP';
        AppLogger.e('Send OTP failed: $error');
        throw Exception(error);
      }
    } on DioException catch (e) {
      AppLogger.e('Send OTP DioException: ${e.type}');
      return _handleDioError(e, 'Failed to send OTP');
    } catch (e) {
      AppLogger.e('Send OTP error: $e');
      rethrow;
    }
  }

  // Resend OTP
  Future<PasswordResetResponse> resendOtp(String email) async {
    try {
      AppLogger.i("🔄 Resending OTP to: $email");

      final response = await ApiService.dio.post(
        '$baseUrl/resend-otp',
        data: ResendOtpRequest(email: email).toJson(),
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      AppLogger.i('Resend OTP response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 429) {
        return PasswordResetResponse.fromJson(response.data);
      } else {
        final error = response.data['message'] ?? 'Failed to resend OTP';
        throw Exception(error);
      }
    } on DioException catch (e) {
      AppLogger.e('Resend OTP DioException: ${e.type}');

      // Handle 429 (Too Many Requests) specially
      if (e.response?.statusCode == 429) {
        return PasswordResetResponse.fromJson(e.response!.data);
      }

      return _handleDioError(e, 'Failed to resend OTP');
    } catch (e) {
      AppLogger.e('Resend OTP error: $e');
      rethrow;
    }
  }

  // Check if can resend
  Future<Map<String, dynamic>> canResendOtp(String email) async {
    try {
      AppLogger.i("🔍 Checking resend availability for: $email");

      final response = await ApiService.dio.get(
        '$baseUrl/can-resend',
        queryParameters: {'email': email},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return {
          'canResend': data['success'] ?? false,
          'remainingSeconds':
              int.tryParse(data['message']?.toString() ?? '0') ?? 0,
        };
      }

      return {'canResend': false, 'remainingSeconds': 30};
    } catch (e) {
      AppLogger.e('Can resend check error: $e');
      return {'canResend': false, 'remainingSeconds': 30};
    }
  }

  // Verify OTP
  Future<PasswordResetResponse> verifyOtp(String email, String otp) async {
    try {
      AppLogger.i("✅ Verifying OTP for: $email");

      final response = await ApiService.dio.post(
        '$baseUrl/verify-otp',
        data: VerifyOtpRequest(email: email, otp: otp).toJson(),
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      AppLogger.i('Verify OTP response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return PasswordResetResponse.fromJson(response.data);
      } else {
        final error = response.data['message'] ?? 'Invalid OTP';
        throw Exception(error);
      }
    } on DioException catch (e) {
      AppLogger.e('Verify OTP DioException: ${e.type}');
      return _handleDioError(e, 'Invalid OTP');
    } catch (e) {
      AppLogger.e('Verify OTP error: $e');
      rethrow;
    }
  }

  // Reset Password
  Future<PasswordResetResponse> resetPassword(
      String email, String newPassword) async {
    try {
      AppLogger.i("🔐 Resetting password for: $email");

      final response = await ApiService.dio.post(
        '$baseUrl/reset',
        data: ResetPasswordRequest(email: email, newPassword: newPassword)
            .toJson(),
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      AppLogger.i('Reset password response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return PasswordResetResponse.fromJson(response.data);
      } else {
        final error = response.data['message'] ?? 'Failed to reset password';
        throw Exception(error);
      }
    } on DioException catch (e) {
      AppLogger.e('Reset password DioException: ${e.type}');
      return _handleDioError(e, 'Failed to reset password');
    } catch (e) {
      AppLogger.e('Reset password error: $e');
      rethrow;
    }
  }

  PasswordResetResponse _handleDioError(DioException e, String defaultMessage) {
    String errorMessage = defaultMessage;

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Server is not responding. Please try again later.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMessage = 'Cannot connect to server. Please check your connection.';
    } else if (e.response != null) {
      AppLogger.e('Response data type: ${e.response!.data.runtimeType}');
      AppLogger.e('Response data: ${e.response!.data}');

      if (e.response!.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['message'] ?? defaultMessage;
      } else if (e.response!.data is String) {
        errorMessage = e.response!.data;
      }
    }

    throw Exception(errorMessage);
  }
}
