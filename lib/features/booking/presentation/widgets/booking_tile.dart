import 'package:flutter/material.dart';

import '../../../../app/app_color.dart';
import '../../../../core/utils/date_time_extension.dart';
import '../../domain/entities/booking_list_item.dart';
import '../../domain/entities/booking_status.dart';

class BookingTile extends StatelessWidget {
  const BookingTile({super.key, required this.booking, this.onTap});

  final BookingListItem booking;
  final VoidCallback? onTap;

  Color get _statusColor {
    switch (booking.status) {
      case BookingStatus.CONFIRM:
        return const Color(0xFF10B981);
      case BookingStatus.PENDING:
        return const Color(0xFFF59E0B);
      case BookingStatus.DRAFT:
        return const Color(0xFF6B7280);
      case BookingStatus.CANCELLED:
        return const Color(0xFFEF4444);
    }
  }

  String get _title {
    if (booking.travellers.isNotEmpty) {
      final name = booking.travellers.first.fullName;
      if (name.isNotEmpty) {
        return name;
      }
    }

    if (booking.stayProviders.isNotEmpty) {
      return booking.stayProviders.first.name;
    }

    if (booking.cabProviders.isNotEmpty) {
      return booking.cabProviders.first.name;
    }

    return "Booking";
  }

  String get _serviceLabel {
    final services = [
      if (booking.hasStayBookings) "Stay",
      if (booking.hasCabBookings) "Transfer",
    ];

    return services.join(" • ");
  }

  String get _amount {
    final amount = booking.totalAmount ?? 0;
    return "\$${(amount / 100).toStringAsFixed(2)}";
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .04),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              /// HEADER
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.luggage_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.bookingDate?.friendlyDateTime ??
                              "No booking date",
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: _statusColor),
                        const SizedBox(width: 6),
                        Text(
                          booking.status.name,
                          style: TextStyle(
                            color: _statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// BODY
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _InfoColumn(
                        label: "REFERENCE",
                        value: "#${booking.id.substring(0, 6)}",
                      ),
                    ),
                    Expanded(
                      child: _InfoColumn(
                        label: "TRAVELLERS",
                        value: "${booking.travellers.length}",
                      ),
                    ),
                    Expanded(
                      child: _InfoColumn(
                        label: "SERVICES",
                        value: _serviceLabel,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// FOOTER
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 18,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _amount,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  FilledButton.icon(
                    onPressed: onTap,
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("View"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.onSurfaceVariant.withValues(alpha: .7),
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
