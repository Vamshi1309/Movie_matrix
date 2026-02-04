class ForgotPasswordRequest {
  final String email;
  ForgotPasswordRequest({required this.email});
  Map<String, dynamic> toJson() => {'email': email};
}

class ResendOtpRequest {
  final String email;
  ResendOtpRequest({required this.email});
  Map<String, dynamic> toJson() => {'email': email};
}

class VerifyOtpRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}

class ResetPasswordRequest {
  final String email;
  final String newPassword;
  ResetPasswordRequest({required this.email, required this.newPassword});
  Map<String, dynamic> toJson() => {'email': email, 'newPassword': newPassword};
}

class PasswordResetResponse {
  final bool success;
  final String message;
  final dynamic data;

  PasswordResetResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
