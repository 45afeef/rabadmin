import '../entities/user_entity.dart';
import '../repositories/users_repository.dart';

/// Use case for creating a new user.
///
/// This use case handles the creation of new users that can then
/// be assigned as staff to an agency.

class CreateUserUseCase {
  final UsersRepository repository;
  CreateUserUseCase(this.repository);

  /// Execute the create user operation
  ///
  /// Parameters:
  /// * [firstName] - The first name of the user
  /// * [lastName] - The last name of the user
  /// * [email] - The email address of the user
  /// * [password] - The password for the user account
  /// * [phone] - Optional phone number
  ///
  /// Returns a map containing the created user data.
  /// Throws an exception if the operation fails.
  Future<UserEntity> call({
    required String fullName,
    required String password,
    required String phone,
  }) async {
    return await repository.createUser(
      fullName: fullName,
      password: password,
      phone: phone,
    );
  }
}
