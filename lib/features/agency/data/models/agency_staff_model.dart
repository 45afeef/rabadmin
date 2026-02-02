import '../../domain/entities/agency_staff.dart';

/// Data model for AgencyStaff.
///
class AgencyStaffModel extends AgencyStaff {
  const AgencyStaffModel({
    required super.id,
    required super.userId,
    required super.travelAgencyId,
    super.role,
  });

  /// Create an AgencyStaffModel from a JSON object received from the API
  ///
  /// The JSON structure expected:
  /// ```json
  /// {
  ///   "id": "string",
  ///   "user_id": "string",
  ///   "travel_agency_id": "string",
  ///   "role": "string"
  /// }
  /// ```
  factory AgencyStaffModel.fromJson(Map<String, dynamic> json) {
    return AgencyStaffModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      travelAgencyId: json['travel_agency_id'] as String,
      role: json['role'] != null ? StaffRole.values.firstWhere((e) => e.name == json['role']) : null,
    );
  }

  /// Convert this model to a JSON object for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'travel_agency_id': travelAgencyId,
      'role': role?.name,
    };
  }

  /// Convert this model to a domain entity
  AgencyStaff toDomain() => AgencyStaff(
    id: id,
    userId: userId,
    travelAgencyId: travelAgencyId,
    role: role,
  );

  /// Create a copy of this model with modified fields
  @override
  AgencyStaffModel copyWith({
    String? id,
    String? userId,
    String? travelAgencyId,
    StaffRole? role,
  }) {
    return AgencyStaffModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      travelAgencyId: travelAgencyId ?? this.travelAgencyId,
      role: role ?? this.role,
    );
  }
}
