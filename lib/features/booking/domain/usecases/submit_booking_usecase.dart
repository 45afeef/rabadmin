import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class SubmitBookingUsecase {
  final BookingRepository repository;

  SubmitBookingUsecase(this.repository);

  Future<void> call(BookingEntity entity) async {
    await repository.createBooking(entity: entity);
  }
}
