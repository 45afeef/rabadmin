import 'package:flutter_riverpod/legacy.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/validate_token_use_case.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/providers/providers.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    ref.read(loginUseCaseProvider),
    ref.read(validateTokenUseCaseProvider),
    ref.read(authRepositoryProvider),
  ),
);

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final ValidateTokenUseCase validateTokenUseCase;
  final AuthRepository repository;

  AuthNotifier(this.loginUseCase, this.validateTokenUseCase, this.repository)
    : super(AuthState.unauthenticated());

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await loginUseCase(email: email, password: password);
      // ask the repository for the stored user ID (it will have been saved
      // during the login call when the token was decoded).
      final userId = await repository.getCurrentUserId();

      state = AuthState.authenticated(userId: userId);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      state = AuthState.unauthenticated();
    }
  }

  Future<void> validateExistingToken() async {
    try {
      final isValid = await validateTokenUseCase();
      if (isValid) {
        final userId = await repository.getCurrentUserId();
        state = AuthState.authenticated(userId: userId);
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
