import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> createProfile({
    String userId,
    required String name,
    String? middleName,
    String? lastName,
    DateTime? dateOfBirth,
    String? profilePicture,
    String? bio,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    required String primaryPhoneNumber,
    String? secondaryPhoneNumber,
    String? primaryEmail,
    String? secondaryEmail,
    required String createdByUserId,
  });
}
