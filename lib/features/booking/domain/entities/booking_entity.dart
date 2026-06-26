import '../../../service_providers/domain/entities/cab_entity.dart';
import '../../../service_providers/domain/entities/stay_provider_entity.dart';
import 'booking_status.dart';
import 'selected_Traveller_entity.dart';

class BookingEntity {
  final String? id;

  final DateTime? startingDate;
  final DateTime? endingDate;

  final BookingStatus status;

  final List<SelectedTravellerEntity> travellers;
  final List<CabEntity> cabs;
  final List<StayProviderEntity> stays;

  final int totalAmount;

  const BookingEntity({
    required this.status,
    required this.travellers,
    required this.cabs,
    required this.stays,
    required this.totalAmount,
    this.id,
    this.startingDate,
    this.endingDate,
  });

  BookingEntity copyWith({
    String? id,
    DateTime? startingDate,
    DateTime? endingDate,
    BookingStatus? status,
    List<SelectedTravellerEntity>? travellers,
    List<CabEntity>? cabs,
    List<StayProviderEntity>? stays,
    int? totalAmount,
  }) {
    return BookingEntity(
      id: id ?? this.id,
      startingDate: startingDate ?? this.startingDate,
      endingDate: endingDate ?? this.endingDate,
      status: status ?? this.status,
      travellers: travellers ?? this.travellers,
      cabs: cabs ?? this.cabs,
      stays: stays ?? this.stays,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
