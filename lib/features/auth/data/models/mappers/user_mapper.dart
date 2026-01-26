import '../user_dto.dart';
import '../../../domain/entitites/user.dart';

extension UserDtoMapper on UserDto {
  User toDomain() {
    return User(id: id, name: name, email: email, avatarUrl: avatarUrl ?? '');
  }
}
