/// Represents a traveller attached to a booking.
///
/// A traveller can be identified in two ways:
///
/// 1. Existing traveller in the system
///    -> identified using [travellerId]
///
/// 2. New / guest traveller
///    -> identified using both [travellerName] and [travellerPhone]
///
/// The class uses named constructors to ensure the object
/// is always created in a valid state.
///
/// This prevents invalid combinations like:
/// - only name
/// - only phone
/// - completely empty traveller
class SelectedTravellerEntity {
  /// Existing traveller identifier from the system.
  final String? travellerId;

  /// Traveller name for guest bookings.
  final String? travellerName;

  /// Traveller phone for guest bookings.
  final String? travellerPhone;

  /// Creates a booking reference for an existing traveller.
  ///
  /// Example:
  /// ```dart
  /// TravellerBooking.byId('TRV123');
  /// ```
  SelectedTravellerEntity.byId(String id)
    : travellerId = id,
      travellerName = null,
      travellerPhone = null {
    // Defensive validation to avoid empty IDs.
    if (id.trim().isEmpty) {
      throw ArgumentError('travellerId cannot be empty.');
    }
  }

  /// Creates a booking for a guest/new traveller.
  ///
  /// Both [name] and [phone] are required.
  ///
  /// Example:
  /// ```dart
  /// TravellerBooking.byGuest(
  ///   travellerName: 'John Doe',
  ///   travellerPhone: '+919876543210',
  /// );
  /// ```
  SelectedTravellerEntity.byGuest({required String name, required String phone})
    : travellerId = null,
      travellerName = name,
      travellerPhone = phone {
    // Validate traveller name.
    if (name.trim().isEmpty) {
      throw ArgumentError('name cannot be empty.');
    }

    // Validate traveller phone.
    if (phone.trim().isEmpty) {
      throw ArgumentError('phone cannot be empty.');
    }
  }

  /// Returns true when this booking references
  /// an existing traveller from the system.
  bool get isExistingTraveller => travellerId != null;

  /// Returns true when this booking represents
  /// a guest/new traveller.
  bool get isGuestTraveller => travellerId == null;
}
