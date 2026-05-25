import '../../../service_providers/domain/entities/cab_entity.dart';
import '../../../service_providers/domain/entities/stay_provider_entity.dart';
import 'booking_status.dart';
import 'selected_Traveller_entity.dart';

class BookingDraftEntity {
  final String? id;

  final DateTime? bookingDate;
  final BookingStatus status;

  final List<SelectedTravellerEntity> travellers;
  final List<CabEntity> cabs;
  final List<StayProviderEntity> stays;

  final int totalAmount;

  const BookingDraftEntity({
    required this.status,
    required this.travellers,
    required this.cabs,
    required this.stays,
    required this.totalAmount,
    this.id,
    this.bookingDate,
  });

  BookingDraftEntity copyWith({
    String? id,
    DateTime? bookingDate,
    BookingStatus? status,
    List<SelectedTravellerEntity>? travellers,
    List<CabEntity>? cabs,
    List<StayProviderEntity>? stays,
    int? totalAmount,
  }) {
    return BookingDraftEntity(
      id: id ?? this.id,
      bookingDate: bookingDate ?? this.bookingDate,
      status: status ?? this.status,
      travellers: travellers ?? this.travellers,
      cabs: cabs ?? this.cabs,
      stays: stays ?? this.stays,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
