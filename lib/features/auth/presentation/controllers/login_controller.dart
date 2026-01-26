import 'package:flutter_riverpod/legacy.dart';
import 'package:rabadmin/core/providers/providers.dart';
import 'package:rabadmin/features/auth/domain/usecases/login_use_case.dart';
import 'package:rabadmin/features/auth/presentation/controllers/login_state.dart';

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
