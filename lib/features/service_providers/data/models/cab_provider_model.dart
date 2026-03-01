import '../../domain/entities/cab_provider_entity.dart';

class CabProviderModel extends CabProviderEntity {
  CabProviderModel({
    required super.id,
    required super.name,
    super.createdBy,
    super.ownerId,
    super.createdAt,
    super.updatedAt,
  });

  factory CabProviderModel.fromJson(
    Map<String, dynamic> json,
  ) => CabProviderModel(
    id: json['id'],
    name: json['provider_name'],
    // TODO : Fix 4 of this :  These fields are required models and entities but may be missing from the API response, so we provide defaults.
    createdBy: json['created_by'] as String?,
    ownerId: json['owner_id'] as String?,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null,
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : null,
  );

  @override
  CabProviderModel copyWith({String? id, String? providerName}) {
    return CabProviderModel(
      id: id ?? this.id,
      name: providerName ?? super.name,
      createdBy: super.createdBy,
      ownerId: super.ownerId,
      createdAt: super.createdAt,
      updatedAt: super.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'providerName': name, 'providerType': type};
  }
}
