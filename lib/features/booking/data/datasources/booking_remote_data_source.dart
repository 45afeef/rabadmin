import '../../domain/entities/booking_entity.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking({required BookingEntity entity});

  Future<BookingModel> getBooking(String id);

  Future<BookingModel> updateBooking(
    String id, {
    String? serviceType,
    String? serviceId,
    Map<String, dynamic>? bookingDetails,
  });

  Future<void> deleteBooking(String id);

  Future<void> submitBooking({
    required String id,
    required Map<String, dynamic> bookingData,
  });

  Future<List<BookingModel>> getAllBookings();
}
