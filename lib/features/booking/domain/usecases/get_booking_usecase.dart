import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingUseCase {
  final BookingRepository repository;

  GetBookingUseCase(this.repository);

  Future<BookingEntity> call(String bookingId) async {
    return await repository.getBooking(bookingId);
  }
}
