import '../repositories/auth_repository.dart';

class ValidateTokenUseCase {
  final AuthRepository repository;

  ValidateTokenUseCase(this.repository);

  Future<bool> call() {
    return repository.validateToken();
  }
}
