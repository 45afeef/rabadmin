import 'booking_remote_data_source.dart';
import '../models/booking_draft_model.dart';
import '../../domain/entities/booking_status.dart';

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  // This will be initialized with BookingsApi from rab_dio in the future
  // For now, we're creating a stub implementation

  BookingRemoteDataSourceImpl();

  @override
  Future<BookingDraftModel> createBookingDraft({
    required String serviceType,
    required String serviceId,
  }) async {
    try {
      // TODO: Implement actual API call using BookingsApi
      // final response = await _bookingsApi.createDraft(
      //   serviceType: serviceType,
      //   serviceId: serviceId,
      // );
      // return BookingDraftModel.fromJson(response);

      // For now, return a stub response
      return BookingDraftModel(
        id: 'draft_${DateTime.now().millisecondsSinceEpoch}',
        status: BookingStatus.DRAFT,
        travellers: [],
        cabs: [],
        stays: [],
        totalAmount: 0,
      );
    } catch (e) {
      throw Exception('Failed to create booking draft: $e');
    }
  }

  @override
  Future<BookingDraftModel> getBookingDraft(String draftId) async {
    try {
      // TODO: Implement actual API call
      throw UnimplementedError('getBookingDraft not implemented');
    } catch (e) {
      throw Exception('Failed to get booking draft: $e');
    }
  }

  @override
  Future<BookingDraftModel> updateBookingDraft(
    String draftId, {
    String? serviceType,
    String? serviceId,
    Map<String, dynamic>? bookingDetails,
  }) async {
    try {
      // TODO: Implement actual API call
      throw UnimplementedError('updateBookingDraft not implemented');
    } catch (e) {
      throw Exception('Failed to update booking draft: $e');
    }
  }

  @override
  Future<void> deleteBookingDraft(String draftId) async {
    try {
      // TODO: Implement actual API call
      throw UnimplementedError('deleteBookingDraft not implemented');
    } catch (e) {
      throw Exception('Failed to delete booking draft: $e');
    }
  }

  @override
  Future<void> submitBooking({
    required String draftId,
    required Map<String, dynamic> bookingData,
  }) async {
    try {
      // TODO: Implement actual API call
      throw UnimplementedError('submitBooking not implemented');
    } catch (e) {
      throw Exception('Failed to submit booking: $e');
    }
  }
}
