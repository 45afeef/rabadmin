import '../../domain/entities/booking_status.dart';

class BookingResponseModel {
  final String id;
  final DateTime? startingDate;
  final DateTime? endingDate;
  final BookingStatus status;
  final int? totalAmount;
  final List<_BookingTraveller> travellers;
  final List<_BookingCabProvider> cabProviders;
  final List<_BookingStayProvider> stayProviders;

  const BookingResponseModel({
    required this.id,
    this.startingDate,
    this.endingDate,
    this.status = BookingStatus.DRAFT,
    this.totalAmount,
    this.travellers = const [],
    this.cabProviders = const [],
    this.stayProviders = const [],
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      id: json['id'] as String,
      startingDate: json['date_starting_from'] != null
          ? DateTime.parse(json['date_starting_from'])
          : null,
      endingDate: json['date_ending_on'] != null
          ? DateTime.parse(json['date_ending_on'])
          : null,
      status: BookingStatus.fromJson(json['status']) ?? BookingStatus.PENDING,
      totalAmount: json['total_amount'],
      travellers:
          (json['travellers'] as List<dynamic>?)
              ?.map((e) => _BookingTraveller.fromJson(e))
              .toList() ??
          [],
      cabProviders:
          (json['cab_providers'] as List<dynamic>?)
              ?.map((e) => _BookingCabProvider.fromJson(e))
              .toList() ??
          [],
      stayProviders:
          (json['stay_providers'] as List<dynamic>?)
              ?.map((e) => _BookingStayProvider.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_starting_from': startingDate?.toIso8601String(),
      'date_ending_on': endingDate?.toIso8601String(),
      'status': status.toJson(),
      'total_amount': totalAmount,
      'travellers': travellers.map((e) => e.toJson()).toList(),
      'cab_providers': cabProviders.map((e) => e.toJson()).toList(),
      'stay_providers': stayProviders.map((e) => e.toJson()).toList(),
    };
  }

  BookingResponseModel copyWith({
    String? id,
    DateTime? startingDate,
    DateTime? endingDate,
    BookingStatus? status,
    int? totalAmount,
    List<_BookingTraveller>? travellers,
    List<_BookingCabProvider>? cabProviders,
    List<_BookingStayProvider>? stayProviders,
  }) {
    return BookingResponseModel(
      id: id ?? this.id,
      startingDate: startingDate ?? this.startingDate,
      endingDate: endingDate ?? this.endingDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      travellers: travellers ?? this.travellers,
      cabProviders: cabProviders ?? this.cabProviders,
      stayProviders: stayProviders ?? this.stayProviders,
    );
  }
}

class _BookingTraveller {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;

  const _BookingTraveller({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
  });

  factory _BookingTraveller.fromJson(Map<String, dynamic> json) {
    return _BookingTraveller(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'phone': phone,
    'email': email,
  };

  _BookingTraveller copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
  }) {
    return _BookingTraveller(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}

class _BookingCabProvider {
  final String id;
  final String name;
  final List<_BookingCab> cabs;

  const _BookingCabProvider({
    required this.id,
    required this.name,
    this.cabs = const [],
  });

  factory _BookingCabProvider.fromJson(Map<String, dynamic> json) {
    return _BookingCabProvider(
      id: json['id'],
      name: json['name'],
      cabs:
          (json['cabs'] as List<dynamic>?)
              ?.map((e) => _BookingCab.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'cabs': cabs.map((e) => e.toJson()).toList(),
  };
}

class _BookingCab {
  final String id;
  final DateTime? pickupTime;
  final String? pickupLocation;
  final DateTime? dropTime;
  final String? dropLocation;
  final int? rate;
  final BookingStatus? status;
  final _BookingCabItem? cab;
  final _BookingDriver? driver;

  const _BookingCab({
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

  factory _BookingCab.fromJson(Map<String, dynamic> json) {
    return _BookingCab(
      id: json['id'],
      pickupTime: json['pickup_time'] != null
          ? DateTime.parse(json['pickup_time'])
          : null,
      pickupLocation: json['pickup_location'],
      dropTime: json['drop_time'] != null
          ? DateTime.parse(json['drop_time'])
          : null,
      dropLocation: json['drop_location'],
      rate: json['rate'],
      status: BookingStatus.fromJson(json['status']),
      cab: json['cab'] != null ? _BookingCabItem.fromJson(json['cab']) : null,
      driver: json['driver'] != null
          ? _BookingDriver.fromJson(json['driver'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'pickup_time': pickupTime?.toIso8601String(),
    'pickup_location': pickupLocation,
    'drop_time': dropTime?.toIso8601String(),
    'drop_location': dropLocation,
    'rate': rate,
    'status': status?.toJson(),
    'cab': cab?.toJson(),
    'driver': driver?.toJson(),
  };
}

class _BookingCabItem {
  final String id;
  final String? name;
  final String? vehicleNumber;
  final String? vehicleType;
  final int? capacity;
  final String? color;
  final String? model;

  const _BookingCabItem({
    required this.id,
    this.name,
    this.vehicleNumber,
    this.vehicleType,
    this.capacity,
    this.color,
    this.model,
  });

  factory _BookingCabItem.fromJson(Map<String, dynamic> json) {
    return _BookingCabItem(
      id: json['id'],
      name: json['name'],
      vehicleNumber: json['vehicle_number'],
      vehicleType: json['vehicle_type'],
      capacity: json['capacity'],
      color: json['color'],
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'vehicle_number': vehicleNumber,
    'vehicle_type': vehicleType,
    'capacity': capacity,
    'color': color,
    'model': model,
  };
}

class _BookingDriver {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? phone;

  const _BookingDriver({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
  });

  factory _BookingDriver.fromJson(Map<String, dynamic> json) {
    return _BookingDriver(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'phone': phone,
  };
}

class _BookingStayProvider {
  final String id;
  final String name;
  final List<_BookingStay> stays;

  const _BookingStayProvider({
    required this.id,
    required this.name,
    this.stays = const [],
  });

  factory _BookingStayProvider.fromJson(Map<String, dynamic> json) {
    return _BookingStayProvider(
      id: json['id'],
      name: json['name'],
      stays:
          (json['stays'] as List<dynamic>?)
              ?.map((e) => _BookingStay.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'stays': stays.map((e) => e.toJson()).toList(),
  };
}

class _BookingStay {
  final String id;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? roomType;
  final int? rate;
  final BookingStatus? status;
  final List<_BookingStayUnit> units;

  const _BookingStay({
    required this.id,
    this.checkIn,
    this.checkOut,
    this.roomType,
    this.rate,
    this.status,
    this.units = const [],
  });

  factory _BookingStay.fromJson(Map<String, dynamic> json) {
    return _BookingStay(
      id: json['id'],
      checkIn: json['check_in'] != null
          ? DateTime.parse(json['check_in'])
          : null,
      checkOut: json['check_out'] != null
          ? DateTime.parse(json['check_out'])
          : null,
      roomType: json['room_type'],
      rate: json['rate'],
      status: BookingStatus.fromJson(json['status']),
      units:
          (json['unit'] as List<dynamic>?)
              ?.map((e) => _BookingStayUnit.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'check_in': checkIn?.toIso8601String(),
    'check_out': checkOut?.toIso8601String(),
    'room_type': roomType,
    'rate': rate,
    'status': status?.toJson(),
    'unit': units.map((e) => e.toJson()).toList(),
  };
}

class _BookingStayUnit {
  final String id;
  final String? name;
  final int? roomRate;
  final int? maxOccupancy;

  const _BookingStayUnit({
    required this.id,
    this.name,
    this.roomRate,
    this.maxOccupancy,
  });

  factory _BookingStayUnit.fromJson(Map<String, dynamic> json) {
    return _BookingStayUnit(
      id: json['id'],
      name: json['name'],
      roomRate: json['room_rate'],
      maxOccupancy: json['max_occupancy'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'room_rate': roomRate,
    'max_occupancy': maxOccupancy,
  };
}
