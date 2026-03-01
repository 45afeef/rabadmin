import '../../domain/entities/stay_amenity_entity.dart';

class StayAmenityModel extends StayAmenityEntity {
  StayAmenityModel({
    required super.id,
    required super.stayServiceProviderId,
    required super.stayUnitId,
    required super.amenityScope,
    required super.amenity,
    super.createdAt,
    super.updatedAt,
  });

  factory StayAmenityModel.fromJson(Map<String, dynamic> json) =>
      StayAmenityModel(
        id: json['id'] as String,
        stayServiceProviderId: json['stay_service_provider_id'] as String,
        stayUnitId: json['stay_unit_id'] as String,
        amenityScope: AmenityScope.values.firstWhere(
          (e) => e.name == json['amenity_scope'],
        ),
        amenity: json['amenity'] as String,
        createdAt: json['created_at'] as DateTime?,
        updatedAt: json['updated_at'] as DateTime?,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stay_service_provider_id': stayServiceProviderId,
      'stay_unit_id': stayUnitId,
      'amenity_scope': amenityScope,
      'amenity': amenity,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  StayAmenityModel copyWith({
    String? id,
    String? stayServiceProviderId,
    String? stayUnitId,
    AmenityScope? amenityScope,
    String? amenity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StayAmenityModel(
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
}
