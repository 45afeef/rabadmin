import 'package:flutter_riverpod/legacy.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../../../core/providers/providers.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.read(loginUseCaseProvider)),
);

class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;

  AuthController(this.loginUseCase) : super(AuthState.unauthenticated());

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null, token: null);

    try {
      final token = await loginUseCase(email: email, password: password);

      state = AuthState.authenticated(token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void logout() {
    state = AuthState.unauthenticated();
  }
}
