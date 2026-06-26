import '../../domain/entities/booking_list_item.dart';
import '../models/booking_response_model.dart';

extension BookingResponseModelMapper on BookingResponseModel {
  BookingListItem toEntity() {
    return BookingListItem(
      id: id,
      startingDate: startingDate,
      endingDate: endingDate,
      status: status,
      totalAmount: totalAmount,
      travellers: travellers
          .map(
            (e) => BookingTraveller(
              id: e.id,
              firstName: e.firstName,
              lastName: e.lastName,
              phone: e.phone,
              email: e.email,
            ),
          )
          .toList(),
      cabProviders: cabProviders
          .map(
            (provider) => BookingCabProvider(
              id: provider.id,
              name: provider.name,
              cabs: provider.cabs
                  .map(
                    (cab) => BookingCab(
                      id: cab.id,
                      pickupTime: cab.pickupTime,
                      pickupLocation: cab.pickupLocation,
                      dropTime: cab.dropTime,
                      dropLocation: cab.dropLocation,
                      rate: cab.rate,
                      status: cab.status,
                      cab: cab.cab != null
                          ? BookingCabItem(
                              id: cab.cab!.id,
                              name: cab.cab!.name,
                              vehicleNumber: cab.cab!.vehicleNumber,
                              vehicleType: cab.cab!.vehicleType,
                              capacity: cab.cab!.capacity,
                              color: cab.cab!.color,
                              model: cab.cab!.model,
                            )
                          : null,
                      driver: cab.driver != null
                          ? BookingDriver(
                              id: cab.driver!.id,
                              firstName: cab.driver!.firstName,
                              lastName: cab.driver!.lastName,
                              phone: cab.driver!.phone,
                            )
                          : null,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
      stayProviders: stayProviders
          .map(
            (provider) => BookingStayProvider(
              id: provider.id,
              name: provider.name,
              stays: provider.stays
                  .map(
                    (stay) => BookingStay(
                      id: stay.id,
                      checkIn: stay.checkIn,
                      checkOut: stay.checkOut,
                      roomType: stay.roomType,
                      rate: stay.rate,
                      status: stay.status,
                      units: stay.units
                          .map(
                            (unit) => BookingStayUnit(
                              id: unit.id,
                              name: unit.name,
                              roomRate: unit.roomRate,
                              maxOccupancy: unit.maxOccupancy,
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
