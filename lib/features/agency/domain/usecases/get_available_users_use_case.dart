import '../entities/user_entity.dart';
import '../repositories/users_repository.dart';

class GetAvailableUsersUseCase {
  final UsersRepository repository;
  GetAvailableUsersUseCase(this.repository);

  Future<List<UserEntity>> call() async {
    return await repository.getAvailableUsers();
  }
}
