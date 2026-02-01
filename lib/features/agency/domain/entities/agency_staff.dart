/// Domain entity representing an agency staff member.
///
/// Contains information about a staff member within an agency.
class AgencyStaff {
  final String id;
  final String userId;
  final String agencyId;
  final String role;
  final String? fullName;
  final String? email;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AgencyStaff({
    required this.id,
    required this.userId,
    required this.agencyId,
    required this.role,
    this.fullName,
    this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy of this agency staff with modified fields
  AgencyStaff copyWith({
    String? id,
    String? userId,
    String? agencyId,
    String? role,
    String? fullName,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AgencyStaff(
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

  @override
  String toString() => 'AgencyStaff(id: $id, userId: $userId, role: $role)';
}
