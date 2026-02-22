import '../../domain/entities/cab_entity.dart';

class CabModel extends CabEntity {
  CabModel({
    required super.id,
    required super.providerId,
    required super.vehicleType,
    required super.vehicleNumber,
    required super.minimumRate,
    required super.kmForMinimumRate,
    required super.perKmRate,
    required super.capacity,
    required super.name,
    required super.companyModel,
    required super.color,
  });

  factory CabModel.fromJson(Map<String, dynamic> json) => CabModel(
    id: json['id'] as String,
    providerId: json['provider_id'] as String,
    vehicleType: VehicleType.values.firstWhere(
      (e) => e.name == json['vehicle_type'],
    ),
    vehicleNumber: json['vehicle_number'] as String,
    minimumRate: json['minimum_rate'] as double,
    kmForMinimumRate: json['km_for_minimum_rate'] as double,
    perKmRate: json['per_km_rate'] as double,
    capacity: json['capacity'] as int,
    name: json['name'] as String,
    companyModel: json['company_model'] as String,
    color: json['color'] as String,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'minimumRate': minimumRate,
      'kmForMinimumRate': kmForMinimumRate,
      'perKmRate': perKmRate,
      'capacity': capacity,
      'name': name,
      'companyModel': companyModel,
      'color': color,
    };
  }

  @override
  CabModel copyWith({
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
    return CabModel(
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
}
