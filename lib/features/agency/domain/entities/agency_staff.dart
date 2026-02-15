/// Staff role enum.
///
enum StaffRole { OWNER, AGENT, MANAGER, SUPPORT }

/// Domain entity representing an agency staff member.
///
class AgencyStaff {
  final String id;
  final String userId;
  final String travelAgencyId;
  final StaffRole role;
  final String? fullName;
  final String? phoneNumber;

  const AgencyStaff({
    required this.id,
    required this.userId,
    required this.travelAgencyId,
    required this.role,
    this.fullName,
    this.phoneNumber,
  });

  /// Create a copy of this agency staff with modified fields
  AgencyStaff copyWith({
    String? id,
    String? userId,
    String? travelAgencyId,
    StaffRole? role,
    String? fullName,
    String? phoneNumber,
  }) {
    return AgencyStaff(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      travelAgencyId: travelAgencyId ?? this.travelAgencyId,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  String toString() =>
      'AgencyStaff(id: $id, userId: $userId, role: $role, fullName: $fullName, phoneNumber: $phoneNumber )';
}
