import '../entities/booking_list_item.dart';
import '../repositories/booking_repository.dart';

class GetBookingListUsecase {
  final BookingRepository repository;

  GetBookingListUsecase(this.repository);

  Future<List<BookingListItem>> call() async {
    return await repository.getBookingList();
  }
}
