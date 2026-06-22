import '../../../service_providers/data/models/cab_model.dart';
import '../../../service_providers/data/models/stay_provider_model.dart';
import '../../../service_providers/domain/entities/cab_entity.dart';
import '../../../service_providers/domain/entities/stay_provider_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/booking_status.dart';
import 'selected_traveler_model.dart';

class BookingModel {
  final String id;

  final DateTime? bookingDate;
  final BookingStatus status;

  final List<SelectedTravellerModel> travellers;
  final List<CabEntity> cabs;
  final List<StayProviderEntity> stays;

  final int totalAmount;

  const BookingModel({
    required this.id,
    required this.bookingDate,
    required this.status,
    required this.travellers,
    required this.cabs,
    required this.stays,
    required this.totalAmount,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      bookingDate: json['booking_date'] != null
          ? DateTime.tryParse(json['booking_date'])
          : null,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.DRAFT,
      ),
      totalAmount: json['total_amount'] ?? 0,
      travellers: (json['travellers'] as List<dynamic>? ?? [])
          .map((e) => SelectedTravellerModel.fromJson(e))
          .toList(),
      cabs: (json['cab_providers'] as List<dynamic>? ?? [])
          .map((e) => CabModel.fromJson(e))
          .toList(),
      stays: (json['stay_providers'] as List<dynamic>? ?? [])
          .map((e) => StayProviderModel.fromJson(e))
          .toList(),
    );
  }

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id!,
      bookingDate: entity.bookingDate,
      status: entity.status,
      totalAmount: entity.totalAmount,
      travellers: entity.travellers
          .map(SelectedTravellerModel.fromEntity)
          .toList(),
      cabs: entity.cabs,
      stays: entity.stays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_date': bookingDate?.toIso8601String(),
      'status': status.name,
      'total_amount': totalAmount,
      'travellers': travellers.map((e) => e.toJson()).toList(),
      'cabs': [],
      'stays': [],
    };
  }

  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      bookingDate: bookingDate,
      status: status,
      totalAmount: totalAmount,
      travellers: travellers.map((e) => e.toEntity()).toList(),
      cabs: cabs,
      stays: stays,
    );
  }
}
