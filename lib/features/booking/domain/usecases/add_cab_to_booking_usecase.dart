import '../entities/booking_status.dart';
import '../repositories/booking_repository.dart';

class AddCabToBookingUseCase {
  final BookingRepository repository;

  AddCabToBookingUseCase(this.repository);

  Future<void> call({
    String? cabId,
    String? cabProviderId,
    String? bookingId,
    String? pickupLocation,
    String? dropLocation,
    DateTime? pickupTime,
    DateTime? dropTime,
    String? driverId,
    int? cost = 0,
    BookingStatus status = BookingStatus.DRAFT,
  }) async {
    repository.addCabtoBooking(
      cabId,
      cabProviderId,
      bookingId,
      pickupLocation,
      dropLocation,
      pickupTime,
      dropTime,
      driverId,
      cost,
      status,
    );
  }
}
