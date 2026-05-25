import '../datasources/booking_remote_data_source.dart';
import '../../domain/entities/booking_draft.dart';
import '../../domain/entities/booking_status.dart';
import '../../domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BookingDraftEntity> createBookingDraft({
    required String serviceType,
    required String serviceId,
  }) async {
    try {
      final model = await remoteDataSource.createBookingDraft(
        serviceType: serviceType,
        serviceId: serviceId,
      );
      return model;
    } catch (e) {
      throw Exception('Failed to create booking draft: $e');
    }
  }

  @override
  Future<BookingDraftEntity> getBookingDraft(String draftId) async {
    try {
      final model = await remoteDataSource.getBookingDraft(draftId);
      return model;
    } catch (e) {
      throw Exception('Failed to get booking draft: $e');
    }
  }

  @override
  Future<BookingDraftEntity> updateBookingDraft(
    String draftId, {
    String? serviceType,
    String? serviceId,
    Map<String, dynamic>? bookingDetails,
  }) async {
    try {
      final model = await remoteDataSource.updateBookingDraft(
        draftId,
        serviceType: serviceType,
        serviceId: serviceId,
        bookingDetails: bookingDetails,
      );
      return model;
    } catch (e) {
      throw Exception('Failed to update booking draft: $e');
    }
  }

  @override
  Future<void> deleteBookingDraft(String draftId) async {
    try {
      await remoteDataSource.deleteBookingDraft(draftId);
    } catch (e) {
      throw Exception('Failed to delete booking draft: $e');
    }
  }

  @override
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
  ) async {
    try {
      final bookingData = {
        'cab_id': cabId,
        'cab_provider_id': cabProviderId,
        'pickup_location': pickupLocation,
        'drop_location': dropLocation,
        'pickup_time': pickupTime?.toIso8601String(),
        'drop_time': dropTime?.toIso8601String(),
        'driver_id': driverId,
        'cost': cost ?? 0,
        'status': status.toString(),
      };

      await remoteDataSource.submitBooking(
        draftId: bookingId ?? 'draft',
        bookingData: bookingData,
      );
    } catch (e) {
      throw Exception('Failed to add cab to booking: $e');
    }
  }
}
