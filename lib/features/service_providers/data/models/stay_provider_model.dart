import '../../domain/entities/stay_provider_entity.dart';

class StayProviderModel extends StayProviderEntity {
  StayProviderModel({
    required super.id,
    required super.name,
    super.roomCount,
    super.createdAt,
    super.updatedAt,
    super.ownerId,
    super.createdBy,
    super.propertyType,
    super.maxOccupancy,
    super.optimalOccupancy,
  });

  factory StayProviderModel.fromJson(Map<String, dynamic> json) =>
      StayProviderModel(
        id: json['id'] as String,
        name: json['provider_name'] as String,
        roomCount: json['room_count'] as int?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
        ownerId: json['owner_id'] as String?,
        createdBy: json['created_by'] as String?,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'providerName': name,
      'providerType': type.toString().split('.').last,
      'roomCount': roomCount,
      'optimalOccupancy': optimalOccupancy,
      'maxOccupancy': maxOccupancy,
      'propertyType': propertyType,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  @override
  StayProviderModel copyWith({
    String? id,
    String? providerName,
    int? roomCount,
    DateTime? updatedAt,
    String? propertyType,
    int? optimalOccupancy,
    int? maxOccupancy,
  }) {
    return StayProviderModel(
      id: this.id,
      name: providerName ?? super.name,
      roomCount: roomCount ?? this.roomCount,
      updatedAt: updatedAt ?? super.updatedAt,
      propertyType: propertyType ?? this.propertyType,
      optimalOccupancy: optimalOccupancy ?? this.optimalOccupancy,
      maxOccupancy: maxOccupancy ?? this.maxOccupancy,
      createdBy: super.createdBy,
      ownerId: super.ownerId,
      createdAt: super.createdAt,
    );
  }
}
