import 'booking_status.dart';

// This object is the data should in the booking list
class BookingListItem {
  final String id;
  final DateTime? startingDate;
  final DateTime? endingDate;
  final BookingStatus status;
  final int? totalAmount;

  final List<BookingTraveller> travellers;
  final List<BookingCabProvider> cabProviders;
  final List<BookingStayProvider> stayProviders;

  const BookingListItem({
    required this.id,
    this.startingDate,
    this.endingDate,
    this.status = BookingStatus.DRAFT,
    this.totalAmount,
    this.travellers = const [],
    this.cabProviders = const [],
    this.stayProviders = const [],
  });

  int get travellerCount => travellers.length;

  bool get hasCabBookings => cabProviders.isNotEmpty;

  bool get hasStayBookings => stayProviders.isNotEmpty;

  int get cabCount {
    return cabProviders.fold(
      0,
      (total, provider) => total + provider.cabs.length,
    );
  }

  int get stayCount =>
      stayProviders.fold(0, (sum, provider) => sum + provider.stays.length);

  int get stayUnitCount => stayProviders.fold(
    0,
    (sum, provider) =>
        sum +
        provider.stays.fold(0, (staySum, stay) => staySum + stay.units.length),
  );
}

class BookingTraveller {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;

  const BookingTraveller({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
  });

  String get fullName {
    return [
      firstName,
      lastName,
    ].where((e) => e != null && e.isNotEmpty).join(' ');
  }
}

class BookingCabProvider {
  final String id;
  final String name;
  final List<BookingCab> cabs;

  const BookingCabProvider({
    required this.id,
    required this.name,
    this.cabs = const [],
  });
}

class BookingCab {
  final String id;

  final DateTime? pickupTime;
  final String? pickupLocation;

  final DateTime? dropTime;
  final String? dropLocation;

  final int? rate;
  final BookingStatus? status;

  final BookingCabItem? cab;
  final BookingDriver? driver;

  const BookingCab({
    required this.id,
    this.pickupTime,
    this.pickupLocation,
    this.dropTime,
    this.dropLocation,
    this.rate,
    this.status,
    this.cab,
    this.driver,
  });

  bool get hasDriver => driver != null;

  bool get hasVehicle => cab != null;
}

class BookingCabItem {
  final String id;

  final String? name;
  final String? vehicleNumber;
  final String? vehicleType;
  final int? capacity;
  final String? color;
  final String? model;

  const BookingCabItem({
    required this.id,
    this.name,
    this.vehicleNumber,
    this.vehicleType,
    this.capacity,
    this.color,
    this.model,
  });
}

class BookingDriver {
  final String id;

  final String? firstName;
  final String? lastName;
  final String? phone;

  const BookingDriver({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
  });

  String get fullName {
    return [
      firstName,
      lastName,
    ].where((e) => e != null && e.isNotEmpty).join(' ');
  }
}

class BookingStayProvider {
  final String id;
  final String name;
  final List<BookingStay> stays;

  const BookingStayProvider({
    required this.id,
    required this.name,
    this.stays = const [],
  });
}

class BookingStay {
  final String id;

  final DateTime? checkIn;
  final DateTime? checkOut;

  final String? roomType;
  final int? rate;

  final BookingStatus? status;

  final List<BookingStayUnit> units;

  const BookingStay({
    required this.id,
    this.checkIn,
    this.checkOut,
    this.roomType,
    this.rate,
    this.status,
    this.units = const [],
  });

  int get totalUnits => units.length;
}

class BookingStayUnit {
  final String id;

  final String? name;
  final int? roomRate;
  final int? maxOccupancy;

  const BookingStayUnit({
    required this.id,
    this.name,
    this.roomRate,
    this.maxOccupancy,
  });
}
