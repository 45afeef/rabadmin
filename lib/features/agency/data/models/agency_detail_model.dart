import 'package:rabadmin/features/agency/domain/entities/agency_staff.dart';

import '../../domain/entities/agency_detail.dart';
import 'agency_staff_model.dart';

/// Data model for AgencyDetail.
///
/// Extended model representing an agency with its staff members.
/// Used when detailed agency information is retrieved from the API.
class AgencyDetailModel {
  final String id;
  final String name;
  final String? description;
  final String? logo;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<AgencyStaffModel> staffs;

  const AgencyDetailModel({
    required this.id,
    required this.name,
    this.description,
    this.logo,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.staffs = const [],
  });

  /// Create an AgencyDetailModel from a JSON object received from the API
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
  ///   "updated_at": "2024-01-01T00:00:00",
  ///   "staffs": [
  ///     {
  ///       "id": "string",
  ///       "user_id": "string",
  ///       "agency_id": "string",
  ///       "role": "string",
  ///       "created_at": "2024-01-01T00:00:00",
  ///       "updated_at": "2024-01-01T00:00:00"
  ///     }
  ///   ]
  /// }
  /// ```
  factory AgencyDetailModel.fromJson(Map<String, dynamic> json) {
    return AgencyDetailModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : json['created_at'] as DateTime,
      updatedAt: json['updated_at'] is String
          ? DateTime.parse(json['updated_at'] as String)
          : json['updated_at'] as DateTime,
      staffs:
          (json['staffs'] as List<dynamic>?)
              ?.map(
                (staff) =>
                    AgencyStaffModel.fromJson(staff as Map<String, dynamic>),
              )
              .toList() ??
          [],
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'staffs': (staffs as List<AgencyStaffModel>)
          .map((staff) => staff.toJson())
          .toList(),
    };
  }

  /// Convert this model to a domain entity
  AgencyDetail toDomain() => AgencyDetail(
    id: id,
    name: name,
    description: description,
    logo: logo,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
    staffs: (staffs as List<AgencyStaffModel>)
        .map((staff) => staff.toDomain())
        .toList(),
  );

  /// Create a copy of this model with modified fields
  AgencyDetailModel copyWithModel({
    String? id,
    String? name,
    String? description,
    String? logo,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AgencyStaffModel>? staffs,
  }) {
    return AgencyDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      staffs: staffs ?? (this.staffs as List<AgencyStaffModel>),
    );
  }

  /// Create a copy of this model with modified fields (compatible with parent)
  @override
  AgencyDetailModel copyWith({
    String? id,
    String? name,
    String? description,
    String? logo,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AgencyStaff>? staffs,
  }) {
    return AgencyDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      staffs: (this.staffs.cast<AgencyStaffModel>()),
    );
  }
}
