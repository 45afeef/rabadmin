import '../entities/booking_entity.dart';
import '../entities/booking_list_item.dart';
import '../entities/booking_status.dart';

abstract class BookingRepository {
  Future<BookingEntity> createBooking({required BookingEntity entity});

  Future<BookingEntity> getBooking(String id);

  Future<BookingEntity> updateBooking(
    String id, {
    String? serviceType,
    String? serviceId,
    Map<String, dynamic>? bookingDetails,
  });

  Future<void> deleteBooking(String id);

  Future<void> addCabtoBooking(
    String? cabId,
    String? cabProviderId,
    String? bookingId,
    String? pickupLocation,
    String? dropLocation,
    DateTime? pickupTime,
    DateTime? dropTime,
    String? driverId,
    int? cost,
    BookingStatus status,
  );

  Future<List<BookingListItem>> getBookingList();
}
