import '../models/booking_draft_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingDraftModel> createBookingDraft({
    required String serviceType,
    required String serviceId,
  });

  Future<BookingDraftModel> getBookingDraft(String draftId);

  Future<BookingDraftModel> updateBookingDraft(
    String draftId, {
    String? serviceType,
    String? serviceId,
    Map<String, dynamic>? bookingDetails,
  });

  Future<void> deleteBookingDraft(String draftId);

  Future<void> submitBooking({
    required String draftId,
    required Map<String, dynamic> bookingData,
  });
}
