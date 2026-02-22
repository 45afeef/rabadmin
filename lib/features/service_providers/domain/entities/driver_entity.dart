class DriverEntity {
  final String? id;
  final String userId;
  final String profileId;
  final String providerId;

  DriverEntity({
    this.id,
    required this.userId,
    required this.profileId,
    required this.providerId,
  });

  DriverEntity copyWith({
    String? id,
    String? userId,
    String? profileId,
    String? providerId,
  }) {
    return DriverEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      profileId: profileId ?? this.profileId,
      providerId: providerId ?? this.providerId,
    );
  }

  @override
  String toString() =>
      'DriverEntity(id: $id, userId: $userId, profileId: '
      '$profileId, providerId: $providerId)';
}
