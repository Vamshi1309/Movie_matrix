class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final String? token;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.token,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    String? token,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      token: token ?? this.token,
    );
  }

  factory AuthState.loading() {
    return AuthState(
      isAuthenticated: false,
      isLoading: true,
    );
  }

  factory AuthState.authenticated(String token) {
    return AuthState(
      isAuthenticated: true,
      isLoading: false,
      token: token,
    );
  }

  factory AuthState.unauthenticated() {
    return AuthState(
      isAuthenticated: false,
      isLoading: false,
    );
  }
}
