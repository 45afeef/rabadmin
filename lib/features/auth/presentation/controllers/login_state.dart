class LoginState {
  final bool isLoading;
  final String? error;
  final String? token;

  const LoginState({this.isLoading = false, this.error, this.token});

  LoginState copyWith({bool? isLoading, String? error, String? token}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      token: token ?? this.token,
    );
  }
}
