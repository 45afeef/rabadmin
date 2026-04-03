class PublicStayUnitEntity {
  String id;
  String name;
  String description;
  double roomRate;
  double perHeadRate;
  int maxOccupancy;
  String providerId;
  String? location;
  List<String>? amenities;

  PublicStayUnitEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.roomRate,
    required this.perHeadRate,
    required this.maxOccupancy,
    required this.providerId,
    this.location,
    this.amenities,
  });
}
