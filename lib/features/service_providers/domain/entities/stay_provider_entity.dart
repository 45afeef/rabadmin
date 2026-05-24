import 'abstract_service_provider.dart';

class StayProviderEntity extends ServiceProvider {
  final ServiceProviderType providerType = ServiceProviderType.STAY;
  final int? roomCount;
  final String? propertyType;
  final int? optimalOccupancy;
  final int? maxOccupancy;

  StayProviderEntity({
    required super.id,
    required super.name,
    super.createdBy,
    this.roomCount,
    super.ownerId,
    super.createdAt,
    super.updatedAt,
    this.propertyType,
    this.optimalOccupancy,
    this.maxOccupancy,
  }) : super(type: ServiceProviderType.STAY);

  @override
  StayProviderEntity copyWith({
    String? id,
    String? providerName,
    int? roomCount,
    DateTime? updatedAt,
    String? propertyType,
    int? optimalOccupancy,
    int? maxOccupancy,
  }) {
    return StayProviderEntity(
      id: this.id,
      name: providerName ?? super.name,
      roomCount: roomCount ?? this.roomCount,
      updatedAt: updatedAt ?? super.updatedAt,
      propertyType: propertyType ?? this.propertyType,
      optimalOccupancy: optimalOccupancy ?? this.optimalOccupancy,
      maxOccupancy: maxOccupancy ?? this.maxOccupancy,
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
