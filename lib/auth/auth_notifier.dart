import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_matrix/auth/auth_state.dart';
import 'package:movie_matrix/core/network/api_service.dart';
import 'package:movie_matrix/data/models/auth_model.dart';
import 'package:movie_matrix/services/auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService)
      : super(AuthState(isAuthenticated: false, isLoading: true)) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isValid = await validateSession();
    final token = isValid ? await _authService.getToken() : null;

    state = AuthState(
      isAuthenticated: isValid,
      isLoading: false,
      token: token,
    );
  }

  Future<bool> validateSession() async {
    final token = await _authService.getToken();

    if (token == null || token.isEmpty) return false;

    try {
      final res = await ApiService.dio.get('/auth/me');
      return res.statusCode == 200;
    } catch (_) {
      await logout(); // 🔥 clear invalid JWT
      return false;
    }
  }

  Future<AuthModel> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authData = await _authService.login(email, password);
      state = AuthState.authenticated(authData.token);
      return authData;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
        isAuthenticated: false,
      );
      rethrow;
    }
  }

  Future<AuthModel> register(String? name, String? number, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authData = await _authService.register(name, number, email, password);
      state = AuthState.authenticated(authData.token);

      return authData;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
        isAuthenticated: false,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState.unauthenticated();
  }
}
