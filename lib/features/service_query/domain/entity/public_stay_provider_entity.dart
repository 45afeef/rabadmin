class PublicStayProviderEntity {
  String id;
  String name;
  String? propertyType;
  int roomCount;
  int? optimalOccupancy;
  int? maxOccupancy;

  PublicStayProviderEntity({
    required this.id,
    required this.name,
    this.propertyType,
    required this.roomCount,
    this.optimalOccupancy,
    this.maxOccupancy,
  });
}
