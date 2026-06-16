import '../entities/booking_draft.dart';
import '../repositories/booking_repository.dart';

class GetBookingListUsecase {
  final BookingRepository repository;

  GetBookingListUsecase(this.repository);

  Future<List<BookingDraftEntity>> call() async {
    return await repository.getBookingList();
  }
}
