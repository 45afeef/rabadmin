class DriverEntity {
  String? id;
  String? userId;
  String providerId;
  String profileId;

  // driver contact/profile details included in query responses so clients
  // can avoid extra nested calls for profile/user lookups.
  String? firstName;
  String? middleName;
  String? lastName;
  String? fullName;
  String? primaryPhoneNumber;
  String? secondaryPhoneNumber;
  String? primaryEmail;
  String? secondaryEmail;
  String? profilePicture;
  String? bio;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  DateTime? createdAt;
  DateTime? updatedAt;

  DriverEntity({
    this.id,
    this.userId,
    required this.profileId,
    required this.providerId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.fullName,
    this.primaryPhoneNumber,
    this.secondaryPhoneNumber,
    this.primaryEmail,
    this.secondaryEmail,
    this.profilePicture,
    this.bio,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.createdAt,
    this.updatedAt,
  });
}
