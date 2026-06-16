import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/utils/date_time_extension.dart';
import '../../../home/presentation/widget/toggle_text.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/booking_status.dart';

class BookingTile extends StatelessWidget {
  const BookingTile({super.key, required this.booking});

  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Row(
        children: [
          Expanded(
            child: Text(
              booking.travellers.isNotEmpty
                  ? booking.travellers.first.travellerName ?? 'No Name Provided'
                  : 'Booking #${booking.id?.substring(0, 6)}',
              // booking.status.name.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '₹${booking.totalAmount}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),

      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Icon(
              Icons.schedule_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: 4),
            ToggleText(
              texts: [
                booking.bookingDate?.relativeTime ?? '',
                booking.bookingDate?.friendlyDate ?? '',
                booking.bookingDate?.friendlyDateTime ?? '',
              ],
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Spacer(),
            _StatusChip(status: booking.status),
          ],
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.push(AppRoutes.bookingDetailPath('${booking.id}'));
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      BookingStatus.CONFIRM => Colors.green,
      BookingStatus.PENDING => Colors.orange,
      BookingStatus.CANCELLED => Colors.red,
      _ => Colors.blue,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
