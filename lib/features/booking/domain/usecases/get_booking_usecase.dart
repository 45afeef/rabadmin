import '../entities/booking_list_item.dart';
import '../repositories/booking_repository.dart';

class GetBookingUseCase {
  final BookingRepository repository;

  GetBookingUseCase(this.repository);

  Future<BookingListItem> call(String bookingId) async {
    return await repository.getBooking(bookingId);
  }
}
