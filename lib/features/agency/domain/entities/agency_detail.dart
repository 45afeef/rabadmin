import 'agency.dart';
import 'agency_staff.dart';

/// Extended agency entity with detailed information including staff members.
///
/// Used when retrieving full agency details with associated staff information.
class AgencyDetail extends Agency {
  final List<AgencyStaff> staffs;

  const AgencyDetail({
    required super.id,
    required super.name,
    super.description,
    super.logo,
    required super.isActive,
    super.createdAt,
    super.updatedAt,
    this.staffs = const [],
  });

  /// Create a copy of this agency detail with modified fields
  @override
  AgencyDetail copyWith({
    String? id,
    String? name,
    String? description,
    String? logo,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AgencyStaff>? staffs,
  }) {
    return AgencyDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      staffs: staffs ?? this.staffs,
    );
  }

  @override
  String toString() =>
      'AgencyDetail(id: $id, name: $name, staffCount: ${staffs.length})';
}
