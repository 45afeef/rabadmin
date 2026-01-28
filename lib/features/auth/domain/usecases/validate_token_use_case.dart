import '../repositories/auth_repository.dart';

class ValidateTokenUseCase {
  final AuthRepository repository;

  ValidateTokenUseCase(this.repository);

  Future<String?> call() {
    return repository.validateToken();
  }
}
