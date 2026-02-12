/// Use case for creating a new user.
///
/// This use case handles the creation of new users that can then
/// be assigned as staff to an agency.
class CreateUserUseCase {
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
  Future<Map<String, dynamic>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
  }) {
    // This will be injected with the actual API calls in the notifier
    throw UnimplementedError('This will be implemented in the notifier');
  }
}
