import '../../domain/entities/agency.dart';

/// Data model for Agency.
///
/// This model represents an agency as received from the API.
/// It includes additional methods for converting to/from JSON and domain entities.
class AgencyModel extends Agency {
  const AgencyModel({
    required super.id,
    required super.name,
    super.description,
    super.logo,
    super.isActive = false,
    super.createdAt,
    super.updatedAt,
  });

  /// Create an AgencyModel from a JSON object received from the API
  ///
  /// The JSON structure expected:
  /// ```json
  /// {
  ///   "id": "string",
  ///   "name": "string",
  ///   "description": "string",
  ///   "logo": "string",
  ///   "is_active": boolean,
  ///   "created_at": "2024-01-01T00:00:00",
  ///   "updated_at": "2024-01-01T00:00:00"
  /// }
  /// ```
  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      id: json['id'] as String,
      name: json['agency_name'] as String,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : json['created_at'] as DateTime,
      updatedAt: json['created_at'] == null
          ? null
          : json['updated_at'] is String
          ? DateTime.parse(json['updated_at'] as String)
          : json['updated_at'] as DateTime,
    );
  }

  /// Convert this model to a JSON object for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Convert this model to a domain entity
  Agency toDomain() => Agency(
    id: id,
    name: name,
    description: description,
    logo: logo,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  /// Create a copy of this model with modified fields
  @override
  AgencyModel copyWith({
    String? id,
    String? name,
    String? description,
    String? logo,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AgencyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
