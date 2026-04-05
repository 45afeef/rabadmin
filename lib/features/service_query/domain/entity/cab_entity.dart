class CabEntity {
  String id;
  String providerId;
  String vehicleType;
  String vehicleNumber;
  double minimumRate;
  double kmForMinimumRate;
  double perKmRate;
  int capacity;
  String name;
  String companyModel;
  String color;

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
}
