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
      'providerName': name,
      'propertyType': type,
      'roomCount': roomCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'ownerId': ownerId,
      'createdBy': createdBy,
    };
  }

  @override
  StayProviderModel copyWith({
    String? id,
    String? providerName,
    int? roomCount,
    DateTime? updatedAt,
  }) {
    return StayProviderModel(
      id: id ?? this.id,
      name: providerName ?? name,
      roomCount: roomCount ?? this.roomCount,
      createdAt: super.createdAt,
      updatedAt: updatedAt ?? super.updatedAt,
      ownerId: super.ownerId,
      createdBy: super.createdBy,
    );
  }
}
