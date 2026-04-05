import '../../domain/entity/public_stay_provider_entity.dart';

class PublicStayProviderModel extends PublicStayProviderEntity {
  PublicStayProviderModel({
    required super.id,
    required super.name,
    super.propertyType,
    required super.roomCount,
    super.optimalOccupancy,
    super.maxOccupancy,
  });

  factory PublicStayProviderModel.fromJson(Map<String, dynamic> json) {
    return PublicStayProviderModel(
      id: json['id'] as String,
      name: json['provider_name'] as String,
      propertyType: json['property_type'] as String?,
      roomCount: json['room_count'] as int,
      optimalOccupancy: json['optimal_occupancy'] ?? 0 as int?,
      maxOccupancy: json['max_occupancy'] ?? 0 as int?,
    );
  }
}
