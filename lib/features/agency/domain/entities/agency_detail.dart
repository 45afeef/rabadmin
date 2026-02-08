import 'agency.dart';

/// Extended agency entity with detailed information.
///
class AgencyDetail extends Agency {
  final String createdBy;
  final DateTime? createdAt;

  const AgencyDetail({
    required super.id,
    required super.agencyName,
    required super.contactEmail,
    super.locationId,
    required this.createdBy,
    this.createdAt,
  });

  /// Create a copy of this agency detail with modified fields
  @override
  AgencyDetail copyWith({
    String? id,
    String? agencyName,
    String? contactEmail,
    String? locationId,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return AgencyDetail(
      id: id ?? this.id,
      agencyName: agencyName ?? this.agencyName,
      contactEmail: contactEmail ?? this.contactEmail,
      locationId: locationId ?? this.locationId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'AgencyDetail(id: $id, agencyName: $agencyName)';
}
