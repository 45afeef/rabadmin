class ProfileEntity {
  String? id;
  String? userId;
  String name;
  String? middleName;
  String? lastName;
  DateTime? dateOfBirth;
  String? profilePicture;
  String? bio;
  String? address;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  String primaryPhoneNumber;
  String? secondaryPhoneNumber;
  String? primaryEmail;
  String? secondaryEmail;
  String createdByUserId;

  ProfileEntity({
    this.id,
    required this.userId,
    required this.name,
    this.middleName,
    this.lastName,
    this.dateOfBirth,
    this.profilePicture,
    this.bio,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    required this.primaryPhoneNumber,
    this.secondaryPhoneNumber,
    this.primaryEmail,
    this.secondaryEmail,
    required this.createdByUserId,
  });
}
