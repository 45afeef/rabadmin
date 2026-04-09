class DriverEntity {
  final String? id;
  final String? userId;
  final String profileId;
  final String providerId;

  // driver contact/profile details included in query responses so clients
  // can avoid extra nested calls for profile/user lookups.
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? fullName;
  final String? primaryPhoneNumber;
  final String? secondaryPhoneNumber;
  final String? primaryEmail;
  final String? secondaryEmail;
  final String? profilePicture;
  final String? bio;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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

  DriverEntity copyWith({
    String? id,
    String? userId,
    String? profileId,
    String? providerId,
    String? firstName,
    String? middleName,
    String? lastName,
    String? fullName,
    String? primaryPhoneNumber,
    String? secondaryPhoneNumber,
    String? primaryEmail,
    String? secondaryEmail,
    String? profilePicture,
    String? bio,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DriverEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      profileId: profileId ?? this.profileId,
      providerId: providerId ?? this.providerId,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      primaryPhoneNumber: primaryPhoneNumber ?? this.primaryPhoneNumber,
      secondaryPhoneNumber: secondaryPhoneNumber ?? this.secondaryPhoneNumber,
      primaryEmail: primaryEmail ?? this.primaryEmail,
      secondaryEmail: secondaryEmail ?? this.secondaryEmail,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'DriverEntity(id: $id, userId: $userId, profileId: '
      '$profileId, providerId: $providerId, fullName: $fullName)';
}
