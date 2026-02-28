import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> createProfile({
    required String name,
    required String createdByUserId,
    required String phoneNumber,
  });
}
