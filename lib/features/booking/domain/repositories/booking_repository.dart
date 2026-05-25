import '../entities/booking_draft.dart';
import '../entities/booking_status.dart';

abstract class BookingRepository {
  Future<BookingDraftEntity> createBookingDraft({
    required BookingDraftEntity draft,
  });

  Future<BookingDraftEntity> getBookingDraft(String draftId);

  Future<BookingDraftEntity> updateBookingDraft(
    String draftId, {
    String? serviceType,
    String? serviceId,
    Map<String, dynamic>? bookingDetails,
  });

  Future<void> deleteBookingDraft(String draftId);

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
}
