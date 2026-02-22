import 'abstract_service_provider.dart';

class CabProviderEntity extends ServiceProvider {
  final ServiceProviderType providerType = ServiceProviderType.CAB;

  CabProviderEntity({
    required super.id,
    required super.name,
    required super.createdBy,
    super.ownerId,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ServiceProviderType.CAB);

  @override
  CabProviderEntity copyWith({String? id, String? providerName}) {
    return CabProviderEntity(
      id: id ?? this.id,
      name: providerName ?? super.name,
      createdBy: super.createdBy,
      ownerId: super.ownerId,
      createdAt: super.createdAt,
      updatedAt: super.updatedAt,
    );
  }

  @override
  String toString() =>
      'CabProviderEntity(id: $id, name: $name, '
      'providerType: $providerType, ownerId: $ownerId,'
      'createdAt: $createdAt, updatedAt: $updatedAt)';
}
