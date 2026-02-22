enum VehicleType {
  SEDAN,
  SUV,
  HATCHBACK,
  VAN;

  @override
  String toString() => name;
}

class CabEntity {
  final String id;
  final String providerId;
  final VehicleType vehicleType;
  final String vehicleNumber;
  final double minimumRate;
  final double kmForMinimumRate;
  final double perKmRate;
  final int capacity;
  final String name;
  final String companyModel;
  final String color;

  CabEntity({
    required this.id,
    required this.providerId,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.minimumRate,
    required this.kmForMinimumRate,
    required this.perKmRate,
    required this.capacity,
    required this.name,
    required this.companyModel,
    required this.color,
  });

  CabEntity copyWith({
    String? id,
    String? providerId,
    VehicleType? vehicleType,
    String? vehicleNumber,
    double? minimumRate,
    double? kmForMinimumRate,
    double? perKmRate,
    int? capacity,
    String? name,
    String? companyModel,
    String? color,
  }) {
    return CabEntity(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      minimumRate: minimumRate ?? this.minimumRate,
      kmForMinimumRate: kmForMinimumRate ?? this.kmForMinimumRate,
      perKmRate: perKmRate ?? this.perKmRate,
      capacity: capacity ?? this.capacity,
      name: name ?? this.name,
      companyModel: companyModel ?? this.companyModel,
      color: color ?? this.color,
    );
  }

  @override
  String toString() =>
      'CabEntity(id: $id, providerId: $providerId, vehicleType: $vehicleType, '
      'vehicleNumber: $vehicleNumber, minimumRate: $minimumRate)';
}
