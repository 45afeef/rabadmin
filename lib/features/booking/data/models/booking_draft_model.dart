import '../../domain/entities/booking_draft.dart';
import '../../domain/entities/booking_status.dart';

class BookingDraftModel extends BookingDraftEntity {
  const BookingDraftModel({
    required super.status,
    required super.travellers,
    required super.cabs,
    required super.stays,
    required super.totalAmount,
    super.id,
    super.bookingDate,
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
      id: entity.id,
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
}
