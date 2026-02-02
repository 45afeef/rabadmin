/// Domain entity representing an agency.
///
/// This entity contains the core business logic data for an agency.
/// It's independent of any external framework or data source.
class Agency {
  final String id;
  final String name;
  final String? description;
  final String? logo;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Agency({
    required this.id,
    required this.name,
    this.description,
    this.logo,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy of this agency with modified fields
  Agency copyWith({
    String? id,
    String? name,
    String? description,
    String? logo,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Agency(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Agency(id: $id, name: $name, isActive: $isActive)';
}
