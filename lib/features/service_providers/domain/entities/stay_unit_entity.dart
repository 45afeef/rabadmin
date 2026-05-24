class StayUnitEntity {
  final String id;
  final String name;
  final String? description;
  final int? roomRate;
  final int? perHeadRate;
  final int? maxOccupancy;
  final String providerId;
  final String? location;
  final List<String>? amenities;
  final int? roomCount;

  StayUnitEntity({
    required this.id,
    required this.name,
    this.description,
    this.roomRate,
    this.perHeadRate,
    this.maxOccupancy,
    required this.providerId,
    this.location,
    this.amenities,
    this.roomCount,
  });

  StayUnitEntity copyWith({
    String? id,
    String? name,
    String? description,
    int? roomRate,
    int? perHeadRate,
    int? maxOccupancy,
    String? providerId,
    String? location,
    List<String>? amenities,
    int? roomCount,
  }) {
    return StayUnitEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      roomRate: roomRate ?? this.roomRate,
      perHeadRate: perHeadRate ?? this.perHeadRate,
      maxOccupancy: maxOccupancy ?? this.maxOccupancy,
      providerId: providerId ?? this.providerId,
      location: location ?? this.location,
      amenities: amenities ?? this.amenities,
      roomCount: roomCount ?? this.roomCount,
    );
  }

  @override
  String toString() =>
      'StayUnitEntity(id: $id, name: $name, providerId: $providerId, '
      'maxOccupancy: $maxOccupancy)';
}
