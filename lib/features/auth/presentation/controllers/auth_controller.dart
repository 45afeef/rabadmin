import 'package:flutter_riverpod/legacy.dart';
import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState.unauthenticated());

  void signIn(String token) {
    // TODO: persist token securely (flutter_secure_storage)
    state = AuthState.authenticated(token);
  }

  void signOut() {
    // TODO: clear token
    state = AuthState.unauthenticated();
  }
}
