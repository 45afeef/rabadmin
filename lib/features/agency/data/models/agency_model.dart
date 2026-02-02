import '../../domain/entities/agency.dart';

/// Data model for Agency.
///
class AgencyModel extends Agency {
  const AgencyModel({
    required super.id,
    required super.agencyName,
    super.contactEmail,
    super.locationId,
  });

  /// Create an AgencyModel from a JSON object received from the API
  ///
  /// The JSON structure expected:
  /// ```json
  /// {
  ///   "id": "string",
  ///   "agency_name": "string",
  ///   "contact_email": "string",
  ///   "location_id": "string"
  /// }
  /// ```
  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      id: json['id'] as String,
      agencyName: json['agency_name'] as String,
      contactEmail: json['contact_email'] as String?,
      locationId: json['location_id'] as String?,
    );
  }

  /// Convert this model to a JSON object for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agency_name': agencyName,
      'contact_email': contactEmail,
      'location_id': locationId,
    };
  }

  /// Convert this model to a domain entity
  Agency toDomain() => Agency(
    id: id,
    agencyName: agencyName,
    contactEmail: contactEmail,
    locationId: locationId,
  );

  /// Create a copy of this model with modified fields
  @override
  AgencyModel copyWith({
    String? id,
    String? agencyName,
    String? contactEmail,
    String? locationId,
  }) {
    return AgencyModel(
      id: id ?? this.id,
      agencyName: agencyName ?? this.agencyName,
      contactEmail: contactEmail ?? this.contactEmail,
      locationId: locationId ?? this.locationId,
    );
  }
}
