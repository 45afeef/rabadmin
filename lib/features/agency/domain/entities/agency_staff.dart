/// Staff role enum.
///
enum StaffRole {
  OWNER,
  AGENT,
  MANAGER,
  SUPPORT,
}

/// Domain entity representing an agency staff member.
///
class AgencyStaff {
  final String id;
  final String userId;
  final String travelAgencyId;
  final StaffRole? role;

  const AgencyStaff({
    required this.id,
    required this.userId,
    required this.travelAgencyId,
    this.role,
  });

  /// Create a copy of this agency staff with modified fields
  AgencyStaff copyWith({
    String? id,
    String? userId,
    String? travelAgencyId,
    StaffRole? role,
  }) {
    return AgencyStaff(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      travelAgencyId: travelAgencyId ?? this.travelAgencyId,
      role: role ?? this.role,
    );
  }

  @override
  String toString() => 'AgencyStaff(id: $id, userId: $userId, role: $role)';
}
