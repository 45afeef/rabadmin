enum ServiceProviderType { CAB, STAY, EXPERIENCE, ACTIVITY, DESTINATION }

abstract class ServiceProvider {
  final String id;
  final ServiceProviderType type;
  final String name;
  final String? createdBy;
  final String? ownerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceProvider({
    required this.id,
    required this.type,
    required this.name,
    this.createdBy,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
  });

  ServiceProvider copyWith();
}
