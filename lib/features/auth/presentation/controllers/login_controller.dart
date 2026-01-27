import 'package:flutter_riverpod/legacy.dart';
import 'package:rabadmin/features/auth/presentation/controllers/auth_controller.dart';

import 'login_state.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../../../core/providers/providers.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
      (ref) => LoginController(
        ref.read(loginUseCaseProvider),
        ref.read(authControllerProvider.notifier),
      ),
    );

class LoginController extends StateNotifier<LoginState> {
  final LoginUseCase loginUseCase;
  final AuthController authController;

  LoginController(this.loginUseCase, this.authController)
    : super(const LoginState());

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final token = await loginUseCase(email: email, password: password);

      /// 🔐 AUTH BOUNDARY
      authController.signIn(token);

      state = state.copyWith(isLoading: false, token: token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void logout() {
    state = state.copyWith(isLoading: false, error: null, token: null);

    authController.signOut();
  }
}
