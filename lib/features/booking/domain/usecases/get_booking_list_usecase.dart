import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingListUsecase {
  final BookingRepository repository;

  GetBookingListUsecase(this.repository);

  Future<List<BookingEntity>> call() async {
    return await repository.getBookingList();
  }
}
