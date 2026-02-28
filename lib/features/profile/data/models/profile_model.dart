import '../../domain/entities/profile.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    super.id,
    super.userId,
    required super.name,
    super.middleName,
    super.lastName,
    super.dateOfBirth,
    super.profilePicture,
    super.bio,
    super.address,
    super.city,
    super.state,
    super.zipCode,
    super.country,
    required super.primaryPhoneNumber,
    super.secondaryPhoneNumber,
    super.primaryEmail,
    super.secondaryEmail,
    required super.createdByUserId,
  });

  static Future<ProfileModel> fromJson(Map<String, dynamic> profileJson) async {
    return ProfileModel(
      id: profileJson['id'] as String,
      userId: profileJson['user_id'] as String?,
      name: profileJson['first_name'] as String,
      middleName: profileJson['middle_name'] as String?,
      lastName: profileJson['last_name'] as String?,
      dateOfBirth: profileJson['date_of_birth'] != null
          ? DateTime.parse(profileJson['date_of_birth'] as String)
          : null,
      profilePicture: profileJson['profile_picture'] as String?,
      bio: profileJson['bio'] as String?,
      address: profileJson['address'] as String?,
      city: profileJson['city'] as String?,
      state: profileJson['state'] as String?,
      zipCode: profileJson['zip_code'] as String?,
      country: profileJson['country'] as String?,
      primaryPhoneNumber: profileJson['primary_phone_number'] as String,
      secondaryPhoneNumber: profileJson['secondary_phone_number'] as String?,
      primaryEmail: profileJson['primary_email'] as String?,
      secondaryEmail: profileJson['secondary_email'] as String?,
      createdByUserId: profileJson['created_by_user_id'] as String,
    );
  }
}
