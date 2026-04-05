import '../../domain/entity/cab_entity.dart';

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

  factory CabModel.fromJson(Map<String, dynamic> json) {
    return CabModel(
      id: json['id'] as String,
      providerId: json['provider_id'] as String,
      vehicleType: json['vehicle_type'] as String,
      vehicleNumber: json['vehicle_number'] as String,
      minimumRate: json['minimum_rate'] as double,
      kmForMinimumRate: json['km_for_minimum_rate'] as double,
      perKmRate: json['per_km_rate'] as double,
      capacity: json['capacity'] as int,
      name: json['name'] as String,
      companyModel: json['company_model'] as String,
      color: json['color'] as String,
    );
  }
}
