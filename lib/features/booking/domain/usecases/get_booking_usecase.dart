import '../entities/booking_draft.dart';
import '../repositories/booking_repository.dart';

class GetBookingUseCase {
  final BookingRepository repository;

  GetBookingUseCase(this.repository);

  Future<BookingDraftEntity> call(String bookingId) async {
    return await repository.getBookingDraft(bookingId);
  }
}
