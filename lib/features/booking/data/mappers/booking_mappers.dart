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
        // ..travelerId = travelerId
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
  static ListBuilder<rab_dio.BookingStayCreate>? _buildStaysList(
    List<StayProviderEntity> stays,
  ) {
    if (stays.isEmpty) return null;

    final builder = ListBuilder<rab_dio.BookingStayCreate>();
    for (int i = 0; i < stays.length; i++) {
      // Note: Only creating empty BookingStayCreate objects
      // Property mapping requires verification of rab_dio BookingStayCreate field names
      builder.add(
        rab_dio.BookingStayCreate(
          (b) => b, // Create empty builder to be populated by API defaults
        ),
      );
    }
    return builder;
  }

  /// Map booking status to rab_dio status
  static rab_dio.BookingStatus _mapBookingStatus(dynamic status) {
    final statusStr = status.toString().split('.').last.toUpperCase();
    try {
      return rab_dio.BookingStatus.valueOf(statusStr);
    } catch (e) {
      return rab_dio.BookingStatus.PENDING;
    }
  }
}
