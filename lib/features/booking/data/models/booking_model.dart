import '../../../service_providers/domain/entities/cab_entity.dart';
import '../../../service_providers/domain/entities/stay_provider_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/booking_status.dart';
import '../../domain/entities/selected_Traveller_entity.dart';

class BookingModel {
  final String id;

  final DateTime? bookingDate;
  final BookingStatus status;

  final List<SelectedTravellerEntity> travellers;
  final List<CabEntity> cabs;
  final List<StayProviderEntity> stays;

  final int totalAmount;

  const BookingModel({
    required this.status,
    required this.travellers,
    required this.cabs,
    required this.stays,
    required this.totalAmount,
    required this.id,
    required this.bookingDate,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      status: BookingStatus.DRAFT,
      travellers: [],
      cabs: [],
      stays: [],
      totalAmount: json['total_amount'] ?? 0,
      bookingDate: json['booking_date'] != null
          ? DateTime.tryParse(json['booking_date'])
          : null,
    );
  }

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id!,
      status: entity.status,
      travellers: entity.travellers,
      cabs: entity.cabs,
      stays: entity.stays,
      totalAmount: entity.totalAmount,
      bookingDate: entity.bookingDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_date': bookingDate?.toIso8601String(),
      'status': status.toString(),
      'total_amount': totalAmount,
      'travellers': [], // will be populated from entities
      'cabs': [],
      'stays': [],
    };
  }

  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      bookingDate: bookingDate,
      status: status,
      travellers: travellers,
      cabs: cabs,
      stays: stays,
      totalAmount: totalAmount,
    );
  }
}
