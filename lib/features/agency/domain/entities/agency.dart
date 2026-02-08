/// Domain entity representing an agency.
///
class Agency {
  final String id;
  final String agencyName;
  final String contactEmail;
  final String? locationId;

  const Agency({
    required this.id,
    required this.agencyName,
    required this.contactEmail,
    this.locationId,
  });

  /// Create a copy of this agency with modified fields
  Agency copyWith({
    String? id,
    String? agencyName,
    String? contactEmail,
    String? locationId,
  }) {
    return Agency(
      id: id ?? this.id,
      agencyName: agencyName ?? this.agencyName,
      contactEmail: contactEmail ?? this.contactEmail,
      locationId: locationId ?? this.locationId,
    );
  }

  @override
  String toString() => 'Agency(id: $id, agencyName: $agencyName)';
}
