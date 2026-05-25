import '../entities/booking_draft.dart';
import '../repositories/booking_repository.dart';

class SubmitBookingUsecase {
  final BookingRepository repository;

  SubmitBookingUsecase(this.repository);

  Future<void> call(BookingDraftEntity bookingDraft) async {
    await repository.createBookingDraft(draft: bookingDraft);
  }
}
