import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rabadmin/features/auth/domain/usecases/login_use_case.dart';
import 'package:rabadmin/features/auth/presentation/controllers/login_controller.dart';
import 'package:rabadmin/features/auth/presentation/controllers/login_state.dart';

// Create a mock class manually
class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late LoginController loginController;
  late MockLoginUseCase mockLoginUseCase;
  late ProviderContainer container;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    container = ProviderContainer();
    loginController = LoginController(mockLoginUseCase);
  });

  tearDown(() {
    container.dispose();
  });

  group('LoginController', () {
    const email = 'test@example.com';
    const password = 'password';
    const token = 'mock_token';

    test('should set token in state when login is successful', () async {
      // Arrange
      when(
        mockLoginUseCase.call(email: email, password: password),
      ).thenAnswer((_) async => token);

      // Act
      await loginController.login(email: email, password: password);

      // Assert
      expect(loginController.state.isLoading, false);
      expect(loginController.state.error, null);
      expect(loginController.state.token, token);
      verify(mockLoginUseCase.call(email: email, password: password)).called(1);
      verifyNoMoreInteractions(mockLoginUseCase);
    });

    test('should set error in state when login fails', () async {
      // Arrange
      const errorMessage = 'Incorrect email or password';
      when(
        mockLoginUseCase.call(email: email, password: password),
      ).thenThrow(Exception(errorMessage));

      // Act
      await loginController.login(email: email, password: password);

      // Assert
      expect(loginController.state.isLoading, false);
      expect(loginController.state.error, errorMessage);
      expect(loginController.state.token, null);
      verify(mockLoginUseCase.call(email: email, password: password)).called(1);
      verifyNoMoreInteractions(mockLoginUseCase);
    });

    test('should set loading to true initially and false after', () async {
      // Arrange
      when(
        mockLoginUseCase.call(email: email, password: password),
      ).thenAnswer((_) async => token);

      // Act
      final future = loginController.login(email: email, password: password);

      // Assert loading is true
      expect(loginController.state.isLoading, true);
      expect(loginController.state.error, null);
      expect(loginController.state.token, null);

      // Wait for completion
      await future;

      // Assert loading is false and token set
      expect(loginController.state.isLoading, false);
      expect(loginController.state.error, null);
      expect(loginController.state.token, token);
    });
  });
}
