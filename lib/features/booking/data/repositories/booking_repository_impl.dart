import 'package:collection/collection.dart';

import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/booking_list_item.dart';
import '../../domain/entities/booking_status.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../mappers/booking_response_model_mapper.dart';
import '../models/booking_response_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  List<BookingEntity>? _cachedBookings;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BookingEntity> createBooking({required BookingEntity entity}) async {
    try {
      final model = await remoteDataSource.createBooking(entity: entity);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  @override
  Future<BookingEntity> getBooking(String id) async {
    final cached = _cachedBookings?.firstWhereOrNull(
      (booking) => booking.id == id,
    );

    if (cached != null) return cached;

    try {
      final model = await remoteDataSource.getBooking(id);
      final entity = model.toEntity();

      _cachedBookings = (_cachedBookings ?? [])..add(entity);
      return entity;
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  @override
  Future<BookingEntity> updateBooking(
    String id, {
    String? serviceType,
    String? serviceId,
    Map<String, dynamic>? bookingDetails,
  }) async {
    try {
      final model = await remoteDataSource.updateBooking(
        id,
        serviceType: serviceType,
        serviceId: serviceId,
        bookingDetails: bookingDetails,
      );
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  @override
  Future<void> deleteBooking(String id) async {
    try {
      await remoteDataSource.deleteBooking(id);
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
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
        id: bookingId ?? 'draft',
        bookingData: bookingData,
      );
    } catch (e) {
      throw Exception('Failed to add cab to booking: $e');
    }
  }

  @override
  Future<List<BookingListItem>> getBookingList() async {
    try {
      final List<BookingResponseModel> bookingsModel = await remoteDataSource
          .getAllBookings();

      final bookings = bookingsModel.map((model) => model.toEntity()).toList();

      return bookings;
    } catch (e) {
      throw Exception('Failed to get staff bookings: $e');
    }
  }
}
