class SelectedCabEntity {
  String? cabId;
  String? cabProviderId;
  String? driverId;
  
  String? pickupTime;
  String? pickupLocation;
  String? dropTime;
  String? dropLocation;
  
  String? rate;
  String? status;

  SelectedCabEntity({
    this.cabId,
    this.cabProviderId,
    this.driverId,

    this.pickupTime,
    this.pickupLocation,
    this.dropTime,
    this.dropLocation,

    this.rate,
    this.status,
  });
}
