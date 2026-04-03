import '../../domain/entity/public_stay_unit_entity.dart';

class PublicStayUnitModel extends PublicStayUnitEntity {
  PublicStayUnitModel({
    required super.id,
    required super.name,
    required super.description,
    required super.roomRate,
    required super.perHeadRate,
    required super.maxOccupancy,
    required super.providerId,
    super.location,
    super.amenities,
  });

  factory PublicStayUnitModel.fromJson(Map<String, dynamic> json) {
    return PublicStayUnitModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      roomRate: (json['room_rate'] as num).toDouble(),
      perHeadRate: (json['per_head_rate'] as num).toDouble(),
      maxOccupancy: json['max_occupancy'] as int,
      providerId: json['provider_id'] as String,
      location: json['location'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }
}
