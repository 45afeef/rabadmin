import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rabadmin/features/auth/domain/repositories/auth_repository.dart';
import 'package:rabadmin/features/auth/domain/usecases/login_use_case.dart';

// Create a mock class manually
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase', () {
    const email = 'test@example.com';
    const password = 'password';
    const token = 'mock_token';

    test('should return token when login is successful', () async {
      // Arrange
      when(
        mockAuthRepository.login(email: email, password: password),
      ).thenAnswer((_) async => token);

      // Act
      final result = await loginUseCase.call(email: email, password: password);

      // Assert
      expect(result, token);
      verify(
        mockAuthRepository.login(email: email, password: password),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should throw exception when login fails', () async {
      // Arrange
      const errorMessage = 'Incorrect email or password';
      when(
        mockAuthRepository.login(email: email, password: password),
      ).thenThrow(Exception(errorMessage));

      // Act & Assert
      expect(
        () => loginUseCase.call(email: email, password: password),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(errorMessage),
          ),
        ),
      );
      verify(
        mockAuthRepository.login(email: email, password: password),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
