import '../../domain/entities/agency_staff.dart';

/// Data model for AgencyStaff.
///
/// Represents a staff member in an agency as received from the API.
/// Includes conversion methods for JSON and domain entities.
class AgencyStaffModel extends AgencyStaff {
  const AgencyStaffModel({
    required String id,
    required String userId,
    required String agencyId,
    required String role,
    String? fullName,
    String? email,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
         id: id,
         userId: userId,
         agencyId: agencyId,
         role: role,
         fullName: fullName,
         email: email,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Create an AgencyStaffModel from a JSON object received from the API
  ///
  /// The JSON structure expected:
  /// ```json
  /// {
  ///   "id": "string",
  ///   "user_id": "string",
  ///   "agency_id": "string",
  ///   "role": "string",
  ///   "full_name": "string",
  ///   "email": "string",
  ///   "created_at": "2024-01-01T00:00:00",
  ///   "updated_at": "2024-01-01T00:00:00"
  /// }
  /// ```
  factory AgencyStaffModel.fromJson(Map<String, dynamic> json) {
    return AgencyStaffModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      agencyId: json['agency_id'] as String,
      role: json['role'] as String,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : json['created_at'] as DateTime,
      updatedAt: json['updated_at'] is String
          ? DateTime.parse(json['updated_at'] as String)
          : json['updated_at'] as DateTime,
    );
  }

  /// Convert this model to a JSON object for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'agency_id': agencyId,
      'role': role,
      'full_name': fullName,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Convert this model to a domain entity
  AgencyStaff toDomain() => AgencyStaff(
    id: id,
    userId: userId,
    agencyId: agencyId,
    role: role,
    fullName: fullName,
    email: email,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  /// Create a copy of this model with modified fields
  @override
  AgencyStaffModel copyWith({
    String? id,
    String? userId,
    String? agencyId,
    String? role,
    String? fullName,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AgencyStaffModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      agencyId: agencyId ?? this.agencyId,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
