// ignore_for_file: constant_identifier_names

enum BookingStatus {
  DRAFT,
  CONFIRM,
  CANCELLED,
  PENDING;

  static BookingStatus? fromJson(String? value) {
    if (value == null) return null;

    return BookingStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BookingStatus.PENDING,
    );
  }

  String toJson() => name;
}
