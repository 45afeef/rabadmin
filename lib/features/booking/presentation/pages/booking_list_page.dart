import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/providers/providers.dart';
import '../widgets/booking_tile.dart';

/// Booking List Page
///
/// Displays all bookings for the current staff member.
/// Fetches from API using staffBookingsProvider.
class BookingListPage extends ConsumerWidget {
  const BookingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings'), elevation: 0),
      body: bookings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())),
        data: (data) => data.isEmpty
            ? const Center(child: Text('No bookings found'))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: data.length,
                  itemBuilder: (_, i) => BookingTile(
                    booking: data[i],
                    onTap: () =>
                        context.push(AppRoutes.bookingDetailPath(data[i].id)),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to booking creation
          context.push(AppRoutes.createBooking);
        },
        tooltip: 'Create Booking',
        child: const Icon(Icons.add),
      ),
    );
  }
}
