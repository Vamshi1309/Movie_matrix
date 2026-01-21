import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_matrix/auth/auth_notifier.dart';
import 'package:movie_matrix/auth/auth_state.dart';
import 'package:movie_matrix/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
