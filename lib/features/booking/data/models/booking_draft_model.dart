import '../../../service_providers/domain/entities/cab_entity.dart';
import '../../../service_providers/domain/entities/stay_provider_entity.dart';
import '../../domain/entities/booking_draft.dart';
import '../../domain/entities/booking_status.dart';
import '../../domain/entities/selected_Traveller_entity.dart';

class BookingDraftModel {
  final String id;

  final DateTime? bookingDate;
  final BookingStatus status;

  final List<SelectedTravellerEntity> travellers;
  final List<CabEntity> cabs;
  final List<StayProviderEntity> stays;

  final int totalAmount;

  const BookingDraftModel({
    required this.status,
    required this.travellers,
    required this.cabs,
    required this.stays,
    required this.totalAmount,
    required this.id,
    required this.bookingDate,
  });

  factory BookingDraftModel.fromJson(Map<String, dynamic> json) {
    return BookingDraftModel(
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

  factory BookingDraftModel.fromEntity(BookingDraftEntity entity) {
    return BookingDraftModel(
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

  BookingDraftEntity toEntity() {
    return BookingDraftEntity(
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
