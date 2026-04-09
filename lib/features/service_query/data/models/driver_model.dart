import '../../domain/entity/driver_entity.dart';

class DriverModel extends DriverEntity {
  DriverModel({
    super.id,
    super.userId,
    required super.profileId,
    required super.providerId,
    super.firstName,
    super.middleName,
    super.lastName,
    super.fullName,
    super.primaryPhoneNumber,
    super.secondaryPhoneNumber,
    super.primaryEmail,
    super.secondaryEmail,
    super.profilePicture,
    super.bio,
    super.address,
    super.city,
    super.state,
    super.zipCode,
    super.country,
    super.createdAt,
    super.updatedAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      profileId: json['profile_id'] as String,
      providerId: json['provider_id'] as String,
      firstName: json['first_name'] as String?,
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String?,
      fullName: json['full_name'] as String?,
      primaryPhoneNumber: json['primary_phone_number'] as String?,
      secondaryPhoneNumber: json['secondary_phone_number'] as String?,
      primaryEmail: json['primary_email'] as String?,
      secondaryEmail: json['secondary_email'] as String?,
      profilePicture: json['profile_picture'] as String?,
      bio: json['bio'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zip_code'] as String?,
      country: json['country'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
