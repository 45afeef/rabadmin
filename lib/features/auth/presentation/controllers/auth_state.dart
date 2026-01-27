class AuthState {
  final bool isAuthenticated;
  final String? token;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.isAuthenticated,
    this.token,
    this.isLoading = false,
    this.error,
  });

  factory AuthState.unauthenticated() {
    return const AuthState(isAuthenticated: false);
  }

  factory AuthState.authenticated(String token) {
    return AuthState(isAuthenticated: true, token: token);
  }

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
