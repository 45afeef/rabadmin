import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../service_providers/domain/entities/cab_entity.dart';
import '../../../service_providers/domain/entities/driver_entity.dart';
import '../../../service_providers/domain/entities/stay_provider_entity.dart';
import '../../domain/entities/booking_draft.dart';
import '../../domain/entities/booking_status.dart';
import '../../domain/entities/selected_Traveller_entity.dart';
import '../../domain/usecases/submit_booking_usecase.dart';

final bookingDraftControllerProvider =
    NotifierProvider<BookingDraftController, BookingDraftEntity>(
      BookingDraftController.new,
    );

class BookingDraftController extends Notifier<BookingDraftEntity> {
  // =========================================================
  // BUILD
  // =========================================================

  @override
  BookingDraftEntity build() {
    return BookingDraftEntity(
      status: BookingStatus.DRAFT,
      travellers: [],
      cabs: [],
      stays: [],
      totalAmount: 0,
    );
  }

  // =========================================================
  // GETTERS
  // =========================================================

  bool get hasTravellers => state.travellers.isNotEmpty;

  bool get hasCabs => state.cabs.isNotEmpty;

  bool get hasStays => state.stays.isNotEmpty;

  bool get isEmpty =>
      state.travellers.isEmpty && state.cabs.isEmpty && state.stays.isEmpty;

  int get travellerCount => state.travellers.length;

  int get cabCount => state.cabs.length;

  int get stayCount => state.stays.length;

  // =========================================================
  // TRAVELLERS
  // =========================================================

  void addTraveller(SelectedTravellerEntity traveller) {
    final updatedTravellers = [...state.travellers, traveller];

    state = state.copyWith(travellers: updatedTravellers);
  }

  void addTravellers(List<SelectedTravellerEntity> travellers) {
    state = state.copyWith(travellers: [...state.travellers, ...travellers]);
  }

  void removeTraveller(int index) {
    if (index < 0 || index >= state.travellers.length) {
      return;
    }

    final updatedTravellers = [...state.travellers];

    updatedTravellers.removeAt(index);

    state = state.copyWith(travellers: updatedTravellers);
  }

  void clearTravellers() {
    state = state.copyWith(travellers: []);
  }

  // =========================================================
  // CABS
  // =========================================================

  void addCab({
    required CabEntity cab,
    DriverEntity? driver,
    String? pickupLocation,
    String? dropLocation,
    DateTime? pickupTime,
    DateTime? dropTime,
    int cost = 0,
  }) {
    final updatedCabs = [...state.cabs, cab];

    state = state.copyWith(
      cabs: updatedCabs,
      totalAmount: state.totalAmount + cost,
    );
  }

  void addCabs(List<CabEntity> cabs) {
    int total = state.totalAmount;

    for (final cab in cabs) {
      total += _calculateCabCost(cab);
    }

    state = state.copyWith(cabs: [...state.cabs, ...cabs], totalAmount: total);
  }

  void removeCab(int index) {
    if (index < 0 || index >= state.cabs.length) {
      return;
    }

    final updatedCabs = [...state.cabs];

    final removedCab = updatedCabs[index];

    updatedCabs.removeAt(index);

    state = state.copyWith(
      cabs: updatedCabs,
      totalAmount: state.totalAmount - _calculateCabCost(removedCab),
    );
  }

  void clearCabs() {
    int remainingTotal = state.totalAmount;

    for (final cab in state.cabs) {
      remainingTotal -= _calculateCabCost(cab);
    }

    state = state.copyWith(cabs: [], totalAmount: remainingTotal);
  }

  // =========================================================
  // STAYS
  // =========================================================

  void addStay({
    required StayProviderEntity stay,
    String? checkIn,
    String? checkOut,
    int cost = 0,
  }) {
    final updatedStays = [...state.stays, stay];

    state = state.copyWith(
      stays: updatedStays,
      totalAmount: state.totalAmount + cost,
    );
  }

  void addStays(List<StayProviderEntity> stays) {
    int total = state.totalAmount;

    state = state.copyWith(
      stays: [...state.stays, ...stays],
      totalAmount: total,
    );
  }

  void removeStay(int index) {
    if (index < 0 || index >= state.stays.length) {
      return;
    }

    final updatedStays = [...state.stays];

    updatedStays.removeAt(index);

    state = state.copyWith(stays: updatedStays);
  }

  void clearStays() {
    int remainingTotal = state.totalAmount;

    state = state.copyWith(stays: [], totalAmount: remainingTotal);
  }

  // =========================================================
  // TOTAL
  // =========================================================

  void recalculateTotal() {
    int total = 0;

    for (final cab in state.cabs) {
      total += _calculateCabCost(cab);
    }

    state = state.copyWith(totalAmount: total);
  }

  void setTotalAmount(int amount) {
    state = state.copyWith(totalAmount: amount);
  }

  // =========================================================
  // STATUS
  // =========================================================

  void updateStatus(BookingStatus status) {
    state = state.copyWith(status: status);
  }

  // =========================================================
  // RESET
  // =========================================================

  void clearDraft() {
    state = BookingDraftEntity(
      status: BookingStatus.DRAFT,
      travellers: [],
      cabs: [],
      stays: [],
      totalAmount: 0,
    );
  }

  // =========================================================
  // PAYLOAD
  // =========================================================

  Map<String, dynamic> payload() {
    return {
      "status": state.status.name,

      "total_amount": state.totalAmount,

      "travellers": state.travellers, //.map((e) => e.toJson()).toList(),

      "cabs": state.cabs, //.map((e) => e.toJson()).toList(),

      "stays": state.stays, //.map((e) => e.toJson()).toList(),
    };
  }

  // =========================================================
  // HELPERS
  // =========================================================

  int _calculateCabCost(CabEntity cab) {
    return int.tryParse(cab.perKmRate.toString()) ?? 0;
  }

  void submitBooking() {
    SubmitBookingUsecase submitUseCase = SubmitBookingUsecase(
      ref.watch(bookingRepositoryProvider),
    );

    submitUseCase.call(state);
  }
}
