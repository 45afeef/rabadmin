import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../domain/entities/booking_entity.dart';

/// Booking Detail Page
///
/// Displays detailed information about a specific booking.
/// Shows:
/// - Booking status
/// - Booking date
/// - Travellers list
/// - Cabs list
/// - Stays list
/// - Total amount
/// - Action buttons (Edit, Cancel, etc.)
class BookingDetailPage extends ConsumerWidget {
  final String bookingId;

  const BookingDetailPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(singleBookingProvider(bookingId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _handleEdit,
            tooltip: 'Edit Booking',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
            tooltip: 'Cancel Booking',
          ),
        ],
      ),
      body: bookingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (booking) => _buildBookingDetails(context, booking),
      ),
    );
  }

  Widget _buildBookingDetails(BuildContext context, BookingEntity booking) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(booking),
          const SizedBox(height: 20),
          _buildSectionTitle('Travellers'),
          _buildTravellersList(booking),
          const SizedBox(height: 20),
          _buildSectionTitle('Cabs'),
          _buildCabsList(booking),
          const SizedBox(height: 20),
          _buildSectionTitle('Stays'),
          _buildStaysList(booking),
          const SizedBox(height: 20),
          _buildTotalAmount(booking),
        ],
      ),
    );
  }

  Widget _buildHeader(BookingEntity booking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Booking ID',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  booking.id ?? 'N/A',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Status',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Chip(label: Text(booking.status.toString().split('.').last)),
              ],
            ),
            if (booking.bookingDate != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Date',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(booking.bookingDate.toString().split(' ')[0]),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTravellersList(BookingEntity booking) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: booking.travellers.length,
      itemBuilder: (context, index) {
        final traveller = booking.travellers[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${traveller.travellerId}'),
          ),
        );
      },
    );
  }

  Widget _buildCabsList(BookingEntity booking) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: booking.cabs.length,
      itemBuilder: (context, index) {
        final cab = booking.cabs[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${cab.id}'),
                // if (cab.type != null) Text('Type: ${cab.type}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStaysList(BookingEntity booking) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: booking.stays.length,
      itemBuilder: (context, index) {
        final stay = booking.stays[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${stay.id}'),
                if (stay.name != null) Text('Name: ${stay.name}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalAmount(BookingEntity booking) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${booking.totalAmount}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEdit() {
    // Navigate to edit page
    // TODO: Implement navigation
  }

  void _handleDelete() {
    // Show confirmation dialog
    // TODO: Implement deletion
  }
}
