import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_matrix/auth/auth_state.dart';
import 'package:movie_matrix/services/auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService)
      : super(AuthState(isAuthenticated: false, isLoading: true)) {
    _checkAuth();
  }

  Future<void> checkAuthStatus() async {
    await _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await _authService.getToken();

    if (token != null && token.isNotEmpty) {
      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        token: token,
      );
    } else {
      state = AuthState(
        isAuthenticated: false,
        isLoading: false,
      );
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await _authService.login(email, password);
      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        token: token,
      );
    } catch (e) {
      state = AuthState(
        isAuthenticated: false,
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await _authService.register(email, password);
      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        token: token,
      );
    } catch (e) {
      state = AuthState(
        isAuthenticated: false,
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState.unauthenticated();
  }
}
