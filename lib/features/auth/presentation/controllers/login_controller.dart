import 'package:flutter_riverpod/legacy.dart';

import 'login_state.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../../../core/providers/providers.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
      (ref) => LoginController(ref.read(loginUseCaseProvider)),
    );

class LoginController extends StateNotifier<LoginState> {
  final LoginUseCase loginUseCase;

  LoginController(this.loginUseCase) : super(const LoginState());

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null, token: null);

    try {
      String token = await loginUseCase(email: email, password: password);

      state = state.copyWith(isLoading: false, token: token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
