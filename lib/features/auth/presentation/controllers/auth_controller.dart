import 'package:flutter_riverpod/legacy.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/validate_token_use_case.dart';
import '../../../../core/providers/providers.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(
    ref.read(loginUseCaseProvider),
    ref.read(validateTokenUseCaseProvider),
  ),
);

class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final ValidateTokenUseCase validateTokenUseCase;

  AuthController(this.loginUseCase, this.validateTokenUseCase)
    : super(AuthState.unauthenticated());

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null, token: null);

    try {
      final token = await loginUseCase(email: email, password: password);

      state = AuthState.authenticated(token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> validateExistingToken() async {
    try {
      final token = await validateTokenUseCase();
      if (token != null) {
        state = AuthState.authenticated(token);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> logout() async {
    try {
      await loginUseCase.repository.logout();
    } catch (e) {
      // Log error but still logout
    }
    state = AuthState.unauthenticated();
  }
}
