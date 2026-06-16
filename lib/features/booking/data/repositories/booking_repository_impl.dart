import 'package:collection/collection.dart';

import '../datasources/booking_remote_data_source.dart';
import '../../domain/entities/booking_draft.dart';
import '../../domain/entities/booking_status.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/booking_draft_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  List<BookingDraftEntity>? _cachedBookings;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BookingDraftEntity> createBookingDraft({
    required BookingDraftEntity draft,
  }) async {
    try {
      final model = await remoteDataSource.createBookingDraft(draft: draft);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to create booking draft: $e');
    }
  }

  @override
  Future<BookingDraftEntity> getBookingDraft(String draftId) async {
    final cachedDraft = _cachedBookings?.firstWhereOrNull(
      (booking) => booking.id == draftId,
    );

    if (cachedDraft != null) return cachedDraft;

    try {
      final model = await remoteDataSource.getBookingDraft(draftId);
      final entity = model.toEntity();

      _cachedBookings = (_cachedBookings ?? [])..add(entity);
      return entity;
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
      return model.toEntity();
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

  @override
  Future<List<BookingDraftEntity>> getBookingList() async {
    try {
      final List<BookingDraftModel> bookingsModel = await remoteDataSource
          .getAllBookings();

      final bookings = bookingsModel.map((model) => model.toEntity()).toList();

      _cachedBookings = bookings;
      return bookings;
    } catch (e) {
      throw Exception('Failed to get staff bookings: $e');
    }
  }
}
