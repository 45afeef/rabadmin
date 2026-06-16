import 'package:rab_dio/rab_dio.dart' hide BookingStatus;

import '../../domain/entities/booking_draft.dart';
import 'booking_remote_data_source.dart';
import '../models/booking_draft_model.dart';
import '../../domain/entities/booking_status.dart';
import '../mappers/booking_mappers.dart';

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final BookingApi api;

  BookingRemoteDataSourceImpl(this.api);

  @override
  Future<BookingDraftModel> createBookingDraft({
    required BookingDraftEntity draft,
  }) async {
    try {
      // Convert domain entity to rab_dio model
      // Note: travelerId and travelAgencyId should be obtained from authentication/profile
      // For now using empty strings as placeholders
      final bookingCreate = BookingMappers.toDioBookingCreate(
        draft,
        travelerId: '',
        travelAgencyId: null,
      );

      // Create booking via API
      await api.bookingCreateBooking(bookingCreate: bookingCreate);

      // Return the draft model with generated ID
      return BookingDraftModel(
        id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
        status: BookingStatus.CONFIRM,
        travellers: draft.travellers,
        cabs: draft.cabs,
        stays: draft.stays,
        totalAmount: draft.totalAmount,
        bookingDate: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  @override
  Future<BookingDraftModel> getBookingDraft(String draftId) async {
    try {
      // Fetch booking details from API
      // This would require a getBooking method on BookingApi
      // For now, throw an error as this might not be implemented in rab_dio yet
      throw UnimplementedError(
        'getBookingDraft not implemented - requires getBooking endpoint',
      );
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
      // Update booking via API
      // This would require an updateBooking method on BookingApi
      throw UnimplementedError(
        'updateBookingDraft not implemented - requires updateBooking endpoint',
      );
    } catch (e) {
      throw Exception('Failed to update booking draft: $e');
    }
  }

  @override
  Future<void> deleteBookingDraft(String draftId) async {
    try {
      // Delete booking via API
      // This would require a deleteBooking method on BookingApi
      throw UnimplementedError(
        'deleteBookingDraft not implemented - requires deleteBooking endpoint',
      );
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
      // This is an alternative submission method that accepts raw booking data
      // Currently the createBookingDraft method is the primary submission path
      throw UnimplementedError('submitBooking with raw data not implemented');
    } catch (e) {
      throw Exception('Failed to submit booking: $e');
    }
  }

  @override
  Future<List<BookingDraftModel>> getAllBookings() async {
    try {
      final response = await api.bookingListBookings();

      return response.data?.map((BookingResponse bookingResponse) {
            final bookingJson = standardSerializers.serializeWith(
              BookingResponse.serializer,
              bookingResponse,
            );

            return BookingDraftModel.fromJson(
              bookingJson as Map<String, dynamic>,
            );
          }).toList() ??
          [];
    } catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }
}
