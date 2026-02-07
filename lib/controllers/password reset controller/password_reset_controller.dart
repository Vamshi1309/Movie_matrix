import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_matrix/core/utils/logger.dart';
import 'package:movie_matrix/services/password_reset_service.dart';

class PasswordResetController extends GetxController {
  final PasswordResetService _service = PasswordResetService();

  // State
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final email = ''.obs;
  final successMsg = ''.obs();

  // Cooldown timer (30 seconds)
  final remainingSeconds = 0.obs;
  final canResend = true.obs;
  Timer? _cooldownTimer;

  // OTP expiry timer (5 minutes)
  final otpExpirySeconds = 300.obs;
  Timer? _expiryTimer;

  @override
  void onClose() {
    _stopTimers();
    super.onClose();
  }

  // ============ SEND OTP ============
  Future<bool> sendOtp(String emailAddress) async {
    isLoading.value = true;
    errorMessage.value = '';
    email.value = emailAddress;

    try {
      final response = await _service.sendOtp(emailAddress);

      if (response.success) {
        _startCooldownTimer(30);
        _startExpiryTimer();
        
        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        AppLogger.i('✅ OTP sent successfully');
        return true;
      } else {
        errorMessage.value = response.message;
        _showErrorSnackbar(response.message);
        return false;
      }
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      errorMessage.value = msg;
      _showErrorSnackbar(msg);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============ RESEND OTP ============
  Future<bool> resendOtp() async {
    if (email.value.isEmpty || !canResend.value) return false;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _service.resendOtp(email.value);

      if (response.success) {
        _startCooldownTimer(30);
        _startExpiryTimer();
        
        Get.snackbar(
          'Success',
          'OTP resent successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        return true;
      } else {
        errorMessage.value = response.message;
        _showErrorSnackbar(response.message);
        return false;
      }
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      errorMessage.value = msg;
      _showErrorSnackbar(msg);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============ VERIFY OTP ============
  Future<bool> verifyOtp(String otp) async {
    if (email.value.isEmpty) return false;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _service.verifyOtp(email.value, otp);

      if (response.success) {
        _stopTimers();
        
        Get.snackbar(
          'Success',
          'OTP verified successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        return true;
      } else {
        errorMessage.value = response.message;
        _showErrorSnackbar(response.message);
        return false;
      }
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      errorMessage.value = msg;
      _showErrorSnackbar(msg);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============ RESET PASSWORD ============
  Future<bool> resetPassword(String newPassword) async {
    if (email.value.isEmpty) return false;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _service.resetPassword(email.value, newPassword);

      if (response.success) {
        _clearState();
        
        Get.snackbar(
          'Success',
          'Password reset successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        return true;
      } else {
        errorMessage.value = response.message;
        _showErrorSnackbar(response.message);
        return false;
      }
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      errorMessage.value = msg;
      _showErrorSnackbar(msg);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============ TIMERS ============
  void _startCooldownTimer(int seconds) {
    remainingSeconds.value = seconds;
    canResend.value = false;
    _cooldownTimer?.cancel();

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void _startExpiryTimer() {
    otpExpirySeconds.value = 300; // 5 minutes
    _expiryTimer?.cancel();

    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpExpirySeconds.value > 0) {
        otpExpirySeconds.value--;
      } else {
        timer.cancel();
        errorMessage.value = 'OTP expired. Please request a new one.';
      }
    });
  }

  void _stopTimers() {
    _cooldownTimer?.cancel();
    _expiryTimer?.cancel();
  }

  void _clearState() {
    email.value = '';
    errorMessage.value = '';
    remainingSeconds.value = 0;
    otpExpirySeconds.value = 300;
    canResend.value = true;
    _stopTimers();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}