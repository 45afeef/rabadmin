import '../../domain/entities/profile.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileEntity> createProfile({
    required String name,
    required String createdByUserId,
    required String phoneNumber,
  }) async {
    final model = await remoteDataSource.createProfile(
      name: name,
      createdByUserId: createdByUserId,
      primaryPhoneNumber: phoneNumber,
    );
    return _mapProfileModelToEntity(model);
  }

  ProfileEntity _mapProfileModelToEntity(ProfileModel model) {
    return ProfileEntity(
      id: model.id,
      userId: model.userId,
      name: model.name,
      createdByUserId: model.createdByUserId,
      primaryPhoneNumber: model.primaryPhoneNumber,
      secondaryPhoneNumber: model.secondaryPhoneNumber,
      primaryEmail: model.primaryEmail,
      secondaryEmail: model.secondaryEmail,
      dateOfBirth: model.dateOfBirth,
      bio: model.bio,
      address: model.address,
      city: model.city,
      state: model.state,
      zipCode: model.zipCode,
      country: model.country,
      lastName: model.lastName,
      middleName: model.middleName,
      profilePicture: model.profilePicture,
    );
  }
}
