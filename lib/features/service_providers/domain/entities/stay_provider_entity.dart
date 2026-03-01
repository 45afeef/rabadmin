import 'abstract_service_provider.dart';

class StayProviderEntity extends ServiceProvider {
  final ServiceProviderType providerType = ServiceProviderType.STAY;
  final int? roomCount;

  StayProviderEntity({
    required super.id,
    required super.name,
    super.createdBy,
    this.roomCount,
    super.ownerId,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ServiceProviderType.STAY);

  @override
  StayProviderEntity copyWith({
    String? id,
    String? providerName,
    int? roomCount,
    DateTime? updatedAt,
  }) {
    return StayProviderEntity(
      id: id ?? this.id,
      name: providerName ?? super.name,
      roomCount: roomCount ?? this.roomCount,
      updatedAt: updatedAt ?? super.updatedAt,
      createdBy: super.createdBy,
      ownerId: super.ownerId,
      createdAt: super.createdAt,
    );
  }

  @override
  String toString() =>
      'StayProviderEntity(id: $id, name: $name, '
      'type: $type, roomCount: $roomCount)';
}
