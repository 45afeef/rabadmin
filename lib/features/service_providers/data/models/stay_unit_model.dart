import '../../domain/entities/stay_unit_entity.dart';

class StayUnitModel extends StayUnitEntity {
  StayUnitModel({
    required super.id,
    required super.name,
    super.description,
    super.roomRate,
    super.perHeadRate,
    super.maxOccupancy,
    required super.providerId,
    super.location,
    super.amenities,
    super.roomCount,
  });

  factory StayUnitModel.fromJson(Map<String, dynamic> json) => StayUnitModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    roomRate: json['room_rate'] as int?,
    perHeadRate: json['per_head_rate'] as int?,
    maxOccupancy: json['max_occupancy'] as int?,
    providerId: json['provider_id'] as String,
    location: json['location'] as String?,
    amenities: (json['amenities'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    roomCount: json['room_count'] as int?,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'roomRate': roomRate,
      'perHeadRate': perHeadRate,
      'maxOccupancy': maxOccupancy,
      'providerId': providerId,
      'location': location,
      'amenities': amenities,
      'roomCount': roomCount,
    };
  }

  @override
  StayUnitModel copyWith({
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
    return StayUnitModel(
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
}
