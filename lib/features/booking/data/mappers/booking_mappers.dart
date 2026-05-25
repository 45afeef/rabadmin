import 'package:built_collection/built_collection.dart';
import 'package:rab_dio/rab_dio.dart' as rab_dio;
import '../../../service_providers/domain/entities/cab_entity.dart';
import '../../../service_providers/domain/entities/stay_provider_entity.dart';
import '../../domain/entities/booking_draft.dart';
import '../../domain/entities/selected_Traveller_entity.dart';

/// Maps domain entities to rab_dio models for API communication
class BookingMappers {
  /// Convert BookingDraftEntity to BookingCreate model
  static rab_dio.BookingCreate toDioBookingCreate(
    BookingDraftEntity booking, {
    required String travelerId,
    required String? travelAgencyId,
  }) {
    return rab_dio.BookingCreate(
      (b) => b
        ..bookingDate = (booking.bookingDate ?? DateTime.now()).toUtc()
        ..status = _mapBookingStatus(booking.status)
        ..totalAmount = booking.totalAmount
        ..travelAgencyId = travelAgencyId
        ..travellers = _buildTravellersList(booking.travellers)
        ..cabs = _buildCabsList(booking.cabs)
        ..stays = _buildStaysList(booking.stays),
    );
  }

  /// Build travellers list for API
  /// Maps SelectedTravellerEntity.travellerId to BookingTravellerCreate
  static ListBuilder<rab_dio.BookingTravellerCreate>? _buildTravellersList(
    List<SelectedTravellerEntity> travellers,
  ) {
    if (travellers.isEmpty) return null;

    final builder = ListBuilder<rab_dio.BookingTravellerCreate>();
    for (final traveller in travellers) {
      builder.add(
        rab_dio.BookingTravellerCreate(
          (b) => b..travellerId = traveller.travellerId,
        ),
      );
    }
    return builder;
  }

  /// Build cabs list for API
  /// Maps CabEntity.id to BookingCabCreate
  static ListBuilder<rab_dio.BookingCabCreate>? _buildCabsList(
    List<CabEntity> cabs,
  ) {
    if (cabs.isEmpty) return null;

    final builder = ListBuilder<rab_dio.BookingCabCreate>();
    for (final cab in cabs) {
      builder.add(rab_dio.BookingCabCreate((b) => b..cabId = cab.id));
    }
    return builder;
  }

  /// Build stays list for API
  /// Maps StayProviderEntity fields to BookingStayCreate model
  /// 
  /// Field Mappings:
  /// - stayProviderId: Maps to stay.id (the stay provider's identifier)
  /// - roomType: Maps to stay.propertyType (e.g., "Apartment", "House")
  /// 
  /// Note: The following fields require additional booking-specific data not currently
  /// stored in StayProviderEntity and would need to be populated separately:
  /// - stayunitId: Unit identifier (from booking selection)
  /// - checkIn: Check-in date (from booking draft)
  /// - checkOut: Check-out date (from booking draft)
  /// - rate: Booking rate/price (from booking draft or pricing service)
  /// - status: Booking status (handled at BookingCreate level)
  static ListBuilder<rab_dio.BookingStayCreate>? _buildStaysList(
    List<StayProviderEntity> stays,
  ) {
    if (stays.isEmpty) return null;

    final builder = ListBuilder<rab_dio.BookingStayCreate>();
    for (final stay in stays) {
      builder.add(
        rab_dio.BookingStayCreate(
          (b) => b
            ..stayProviderId = stay.id
            ..roomType = stay.propertyType,
            // TODO: Populate booking-specific fields from enhanced entity:
            // ..stayunitId = stay.stayunitId (requires entity enhancement)
            // ..checkIn = stay.checkInDate (requires entity enhancement)
            // ..checkOut = stay.checkOutDate (requires entity enhancement)
            // ..rate = stay.rate (requires entity enhancement)
            // ..status = _mapBookingStatus(stay.status) (requires entity enhancement)
        ),
      );
    }
    return builder;
  }

  /// Map booking status from domain enum to rab_dio BookingStatus
  /// Converts status to uppercase string and uses valueOf for matching
  /// Defaults to PENDING if status cannot be mapped
  static rab_dio.BookingStatus _mapBookingStatus(dynamic status) {
    final statusStr = status.toString().split('.').last.toUpperCase();
    try {
      return rab_dio.BookingStatus.valueOf(statusStr);
    } catch (e) {
      return rab_dio.BookingStatus.PENDING;
    }
  }
}
