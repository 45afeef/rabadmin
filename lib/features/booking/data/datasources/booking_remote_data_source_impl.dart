import 'package:rab_dio/rab_dio.dart' hide BookingStatus;

import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/booking_status.dart';
import '../mappers/booking_mappers.dart';
import '../models/booking_model.dart';
import '../models/booking_response_model.dart';
import '../models/selected_traveler_model.dart';
import 'booking_remote_data_source.dart';

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final BookingApi api;

  BookingRemoteDataSourceImpl(this.api);

  @override
  Future<BookingModel> createBooking({required BookingEntity entity}) async {
    try {
      // Convert domain entity to rab_dio model
      // Note: travelerId and travelAgencyId should be obtained from authentication/profile
      // For now using empty strings as placeholders
      final bookingCreate = BookingMappers.toDioBookingCreate(
        entity,
        travelAgencyId: null,
      );

      // Create booking via API
      await api.bookingCreateBooking(bookingCreate: bookingCreate);

      // Return the draft model with generated ID
      return BookingModel(
        id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
        status: BookingStatus.CONFIRM,
        travellers: entity.travellers
            .map(SelectedTravellerModel.fromEntity)
            .toList(),
        cabs: entity.cabs,
        stays: entity.stays,
        totalAmount: entity.totalAmount,
        bookingDate: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  @override
  Future<BookingResponseModel> getBooking(String id) async {
    try {
      // Fetch booking details from API

      final response = await api.bookingGetBooking(bookingId: id);

      final bookingJson = standardSerializers.serializeWith(
        BookingResponse.serializer,
        response.data,
      );

      return BookingResponseModel.fromJson(bookingJson as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  @override
  Future<BookingModel> updateBooking(
    String id, {
    String? serviceType,
    String? serviceId,
    Map<String, dynamic>? bookingDetails,
  }) async {
    try {
      // Update booking via API
      // This would require an updateBooking method on BookingApi
      throw UnimplementedError(
        'updateBooking not implemented - requires updateBooking endpoint',
      );
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  @override
  Future<void> deleteBooking(String id) async {
    try {
      // Delete booking via API
      // This would require a deleteBooking method on BookingApi
      throw UnimplementedError(
        'deleteBooking not implemented - requires deleteBooking endpoint',
      );
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }

  @override
  Future<void> submitBooking({
    required String id,
    required Map<String, dynamic> bookingData,
  }) async {
    try {
      // This is an alternative submission method that accepts raw booking data
      // Currently the createBooking method is the primary submission path
      throw UnimplementedError('submitBooking with raw data not implemented');
    } catch (e) {
      throw Exception('Failed to submit booking: $e');
    }
  }

  @override
  Future<List<BookingResponseModel>> getAllBookings() async {
    try {
      final response = await api.bookingListBookings();

      return response.data?.map((BookingResponse bookingResponse) {
            final bookingJson = standardSerializers.serializeWith(
              BookingResponse.serializer,
              bookingResponse,
            );

            return BookingResponseModel.fromJson(
              bookingJson as Map<String, dynamic>,
            );
          }).toList() ??
          [];
    } catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }
}
