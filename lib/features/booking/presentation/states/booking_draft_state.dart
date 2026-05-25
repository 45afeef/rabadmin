import '../../domain/entities/booking_draft.dart';

abstract class BookingDraftState {}

class BookingDraftLoadingState extends BookingDraftState {}

class BookingDraftInitialState extends BookingDraftState {}

class BookingDraftingState extends BookingDraftState {
  BookingDraftEntity bookingDraft;
  BookingDraftingState(this.bookingDraft);
}

class BookingDraftError extends BookingDraftState {
  final String message;
  BookingDraftError(this.message);
}
