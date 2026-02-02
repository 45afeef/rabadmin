import '../../domain/entities/agency_detail.dart';

/// Data model for AgencyDetail.
///
class AgencyDetailModel extends AgencyDetail {
  const AgencyDetailModel({
    required super.id,
    required super.agencyName,
    super.contactEmail,
    super.locationId,
    required super.createdBy,
    super.createdAt,
  });

  /// Create an AgencyDetailModel from a JSON object received from the API
  ///
  /// The JSON structure expected:
  /// ```json
  /// {
  ///   "id": "string",
  ///   "agency_name": "string",
  ///   "contact_email": "string",
  ///   "location_id": "string",
  ///   "created_by": "string",
  ///   "created_at": "2024-01-01T00:00:00"
  /// }
  /// ```
  factory AgencyDetailModel.fromJson(Map<String, dynamic> json) {
    return AgencyDetailModel(
      id: json['id'] as String,
      agencyName: json['agency_name'] as String,
      contactEmail: json['contact_email'] as String?,
      locationId: json['location_id'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convert this model to a JSON object for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agency_name': agencyName,
      'contact_email': contactEmail,
      'location_id': locationId,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Convert this model to a domain entity
  AgencyDetail toDomain() => AgencyDetail(
    id: id,
    agencyName: agencyName,
    contactEmail: contactEmail,
    locationId: locationId,
    createdBy: createdBy,
    createdAt: createdAt,
  );



  /// Create a copy of this model with modified fields (compatible with parent)
  @override
  AgencyDetailModel copyWith({
    String? id,
    String? agencyName,
    String? contactEmail,
    String? locationId,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return AgencyDetailModel(
      id: id ?? this.id,
      agencyName: agencyName ?? this.agencyName,
      contactEmail: contactEmail ?? this.contactEmail,
      locationId: locationId ?? this.locationId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
