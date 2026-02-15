import '../../domain/entities/agency_staff.dart';

/// Data model for AgencyStaff.
///
class AgencyStaffModel extends AgencyStaff {
  const AgencyStaffModel({
    required super.id,
    required super.userId,
    required super.travelAgencyId,
    required super.role,
    super.fullName,
    super.phoneNumber,
  });

  /// Create an AgencyStaffModel from a JSON object received from the API
  ///
  /// The JSON structure expected:
  /// ```json
  /// {
  ///   "id": "string",
  ///   "user_id": "string",
  ///   "travel_agency_id": "string",
  ///   "role": "string",
  ///   "full_name": "string",
  ///   "phone_number": "string"
  /// }
  /// ```
  factory AgencyStaffModel.fromJson(Map<String, dynamic> json) {
    return AgencyStaffModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      travelAgencyId: json['travel_agency_id'] as String,
      role: StaffRole.values.firstWhere((e) => e.name == json['role']),
      fullName: json['full_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }

  /// Convert this model to a JSON object for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'travel_agency_id': travelAgencyId,
      'role': role.name,
      'full_name': fullName,
      'phone_number': phoneNumber,
    };
  }

  /// Convert this model to a domain entity
  AgencyStaff toDomain() => AgencyStaff(
    id: id,
    userId: userId,
    travelAgencyId: travelAgencyId,
    role: role,
    fullName: fullName,
    phoneNumber: phoneNumber,
  );

  /// Create a copy of this model with modified fields
  @override
  AgencyStaffModel copyWith({
    String? id,
    String? userId,
    String? travelAgencyId,
    StaffRole? role,
    String? fullName,
    String? phoneNumber,
  }) {
    return AgencyStaffModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      travelAgencyId: travelAgencyId ?? this.travelAgencyId,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
