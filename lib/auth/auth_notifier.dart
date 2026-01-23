import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_matrix/auth/auth_state.dart';
import 'package:movie_matrix/data/models/auth_model.dart';
import 'package:movie_matrix/services/auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService)
      : super(AuthState(isAuthenticated: false, isLoading: true)) {
    _checkAuth();
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

  Future<AuthModel> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authData = await _authService.login(email, password);
      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        token: authData.token,
      );

      return authData;
    } catch (e) {
      state = AuthState(
        isAuthenticated: false,
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<AuthModel> register(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authData = await _authService.register(email, password);
      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        token: authData.token,
      );

      return authData;
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
