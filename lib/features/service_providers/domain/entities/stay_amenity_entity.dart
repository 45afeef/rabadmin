enum AmenityScope {
  ROOM,
  COMMON,
  PRIVATE;

  @override
  String toString() => name;
}

class StayAmenityEntity {
  final String id;
  final String stayServiceProviderId;
  final String stayUnitId;
  final AmenityScope amenityScope;
  final String amenity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StayAmenityEntity({
    required this.id,
    required this.stayServiceProviderId,
    required this.stayUnitId,
    required this.amenityScope,
    required this.amenity,
    this.createdAt,
    this.updatedAt,
  });

  StayAmenityEntity copyWith({
    String? id,
    String? stayServiceProviderId,
    String? stayUnitId,
    AmenityScope? amenityScope,
    String? amenity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StayAmenityEntity(
      id: id ?? this.id,
      stayServiceProviderId:
          stayServiceProviderId ?? this.stayServiceProviderId,
      stayUnitId: stayUnitId ?? this.stayUnitId,
      amenityScope: amenityScope ?? this.amenityScope,
      amenity: amenity ?? this.amenity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'StayAmenityEntity(id: $id, stayUnitId: $stayUnitId, '
      'amenity: $amenity, amenityScope: $amenityScope)';
}
