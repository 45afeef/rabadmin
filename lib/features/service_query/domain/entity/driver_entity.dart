class DriverEntity {
  String id;
  String? userId;
  String profileId;
  String providerId;

  DriverEntity({
    required this.id,
    this.userId,
    required this.profileId,
    required this.providerId,
  });
}
