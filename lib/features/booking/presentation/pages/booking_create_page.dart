import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/booking_draft_notifier.dart';
import '../widgets/booking_create_widget.dart';

/// Booking Create/Edit Page
///
/// Full-screen page for creating or editing a booking.
/// Manages booking form state through BookingDraftNotifier.
///
/// States:
/// - Initial: Page loaded, showing empty form
/// - Loading: Submitting booking
/// - Success: Booking created/updated
/// - Error: Form submission failed
class BookingCreatePage extends ConsumerStatefulWidget {
  final String? bookingId;

  const BookingCreatePage({super.key, this.bookingId});

  @override
  ConsumerState<BookingCreatePage> createState() => _BookingCreatePageState();
}

class _BookingCreatePageState extends ConsumerState<BookingCreatePage> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.bookingId == null ? 'Create Booking' : 'Edit Booking',
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Main form
          BookingFormWidget(showSubmitButton: true, onSubmit: _handleSubmit),

          // Loading overlay
          if (_isSubmitting)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  void _handleSubmit() async {
    final notifier = ref.read(bookingDraftNotifierProvider.notifier);

    setState(() => _isSubmitting = true);

    try {
      // Submit booking using notifier
      await notifier.submitBooking();

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking created successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
