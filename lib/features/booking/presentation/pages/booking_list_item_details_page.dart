import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_color.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/utils/date_time_extension.dart';
import '../../domain/entities/booking_list_item.dart';
import '../../domain/entities/booking_status.dart';

class BookingListItemDetailsPage extends ConsumerWidget {
  final String bookingId;

  const BookingListItemDetailsPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(singleBookingProvider(bookingId));

    return Scaffold(
      body: bookingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (booking) => _buildBookingDetails(context, booking),
      ),
    );
  }

  Widget _buildBookingDetails(BuildContext context, BookingListItem booking) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth > 900;

          return desktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 260, child: _Sidebar()),
                    const SizedBox(width: 24),
                    Expanded(child: _MainContent(booking: booking)),
                  ],
                )
              : _MainContent(booking: booking);
        },
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primaryContainer,
            child: Icon(Icons.analytics, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            "Alex Sterling",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text("Premium Tier Agent", style: TextStyle(fontSize: 12)),
          const SizedBox(height: 24),
          _menu(Icons.dashboard, "Dashboard"),
          _menu(Icons.storefront, "Marketplace"),
          _menu(Icons.event_note, "Bookings", active: true),
          _menu(Icons.chat, "Messages"),
          _menu(Icons.group, "Staff"),
        ],
      ),
    );
  }

  Widget _menu(IconData icon, String title, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active ? AppColors.brand200 : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [Icon(icon), const SizedBox(width: 12), Text(title)],
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final BookingListItem booking;

  const _MainContent({required this.booking});

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return "${date.toLocal().toString().split(' ')[0]}";
  }

  String _buildTitle() {
    if (booking.stayProviders.isNotEmpty) {
      return booking.stayProviders.first.name;
    }

    if (booking.cabProviders.isNotEmpty) {
      return booking.cabProviders.first.name;
    }

    return "Booking Details";
  }

  String _buildSubtitle() {
    final dateStr = booking.bookingDate != null
        ? booking.bookingDate!.friendlyDateTime
        : "N/A";
    final services = [
      if (booking.hasCabBookings) "Transportation",
      if (booking.hasStayBookings) "Accommodation",
    ];
    final serviceStr = services.isNotEmpty ? services.join(" & ") : "Service";
    return "$dateStr • $serviceStr";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _buildTitle(),
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _buildSubtitle(),
          style: const TextStyle(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () {},
                child: Text("Download PDF"),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () {},
                child: Text("Modify Itinerary"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth > 1000;

            return desktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _LeftColumn(booking: booking)),
                      const SizedBox(width: 24),
                      Expanded(child: _RightColumn(booking: booking)),
                    ],
                  )
                : Column(
                    children: [
                      _LeftColumn(booking: booking),
                      const SizedBox(height: 20),
                      _RightColumn(booking: booking),
                    ],
                  );
          },
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  final BookingListItem booking;

  const _StatusCard({required this.booking});

  String _statusToDisplayText(BookingStatus status) {
    return "${status.toString().split('.').last} & Active";
  }

  int _getActiveStep() {
    // Map booking status to step number
    switch (booking.status) {
      case BookingStatus.DRAFT:
        return 1;
      case BookingStatus.CONFIRM:
        return 2;
      case BookingStatus.PENDING:
        return 3;
      case BookingStatus.CANCELLED:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeStep = _getActiveStep();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  ...["CURRENT STATUS", "BOOKING REF"].map(
                    (t) => Text(
                      t,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: activeStep > 0
                            ? AppColors.success
                            : AppColors.gray200,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _statusToDisplayText(booking.status),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '#${booking.id.substring(0, 6)}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StepItem(number: "1", label: "Inquiry", active: activeStep >= 1),
              _StepItem(
                number: "2",
                label: "Confirmed",
                active: activeStep >= 2,
              ),
              _StepItem(number: "3", label: "Paid", active: activeStep >= 3),
              _StepItem(number: "4", label: "Arrival", active: activeStep >= 4),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String label;
  final bool active;

  const _StepItem({
    required this.number,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: active ? AppColors.primary : AppColors.gray200,
          child: Text(
            number,
            style: TextStyle(
              color: active ? Colors.white : AppColors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final BookingListItem booking;

  const _TimelineCard({required this.booking});

  String _getServiceTypeColor(bool isCab) {
    return isCab ? "Transfer" : "Accommodation";
  }

  String _formatTimelineDate(DateTime date) {
    return date.toLocal().toString().split(' ')[0];
  }

  String _formatTimelineTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    for (final provider in booking.cabProviders) {
      for (final cab in provider.cabs) {
        items.add(
          TimelineTile(
            date: cab.pickupTime != null
                ? _formatTimelineDate(cab.pickupTime!)
                : "N/A",
            time: cab.pickupTime != null
                ? _formatTimelineTime(cab.pickupTime!)
                : "TBD",
            title: cab.cab?.name ?? provider.name,
            subtitle:
                "${cab.cab?.model ?? ''} - ${cab.cab?.vehicleNumber ?? ''}",
            tagIcon: Icons.directions_bike_outlined,
            tag: "Transfer",
            tagColor: AppColors.success,
          ),
        );

        items.add(const Divider());
      }
    }

    for (final provider in booking.stayProviders) {
      for (final stay in provider.stays) {
        items.add(
          TimelineTile(
            date: stay.checkIn != null
                ? _formatTimelineDate(stay.checkIn!)
                : "N/A",
            time: "Check-in",
            title: provider.name,
            subtitle: stay.roomType ?? "Stay",
            tagIcon: Icons.villa,
            tag: "Accommodation",
            tagColor: Colors.blue,
          ),
        );

        items.add(const Divider());
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Service Items",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          ...items,
        ],
      ),
    );
  }
}

class TimelineTile extends StatelessWidget {
  final String date;
  final String time;
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final IconData tagIcon;

  const TimelineTile({
    super.key,
    required this.date,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.tagIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(time),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(tagIcon, size: 12, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeftColumn extends StatelessWidget {
  final BookingListItem booking;

  const _LeftColumn({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatusCard(booking: booking),
        const SizedBox(height: 24),
        _TimelineCard(booking: booking),
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  final BookingListItem booking;

  const _RightColumn({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PassengerProfilesCard(booking: booking),
        const SizedBox(height: 20),
        _FinancialCard(booking: booking),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;

  const _InfoCard({required this.title, required this.child, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray100,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _PassengerProfilesCard extends StatelessWidget {
  final BookingListItem booking;

  const _PassengerProfilesCard({required this.booking});

  String _getTravellerName(BookingTraveller traveller) {
    if (traveller.fullName.isNotEmpty) {
      return traveller.fullName;
    }

    return traveller.email ?? traveller.phone ?? traveller.id;
  }

  String _getTravellerSubtitle(int index) {
    if (index == 0) {
      return "Lead Passenger";
    }
    return "Guest";
  }

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: "Passenger Profiles",
      icon: Icons.people_alt,
      child: booking.travellers.isNotEmpty
          ? Column(
              children: List.generate(booking.travellers.length, (index) {
                final traveller = booking.travellers[index];
                return ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(_getTravellerName(traveller)),
                  subtitle: Text(_getTravellerSubtitle(index)),
                );
              }),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "No passengers added",
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
            ),
    );
  }
}

class _FinancialCard extends StatelessWidget {
  final BookingListItem booking;

  const _FinancialCard({required this.booking});

  String _formatCurrency(int amount) {
    return "\$${(amount / 100).toStringAsFixed(2)}";
  }

  int _calculateCommission(int total) {
    // Assuming 15% commission
    return (total * 0.15).toInt();
  }

  int _calculateTaxesFees(int total) {
    // Assuming 5% taxes and fees
    return (total * 0.05).toInt();
  }

  @override
  Widget build(BuildContext context) {
    final total = booking.totalAmount ?? 0;

    final commission = _calculateCommission(total);
    final taxesFees = _calculateTaxesFees(total);
    final totalBalance = total + commission + taxesFees;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            bottom: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FINANCIAL OVERVIEW',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.7),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                _FinanceRow(
                  title: 'Total Itinerary Cost',
                  value: _formatCurrency(total),
                ),
                const SizedBox(height: 12),
                _FinanceRow(
                  title: 'Agency Commission',
                  value: _formatCurrency(commission),
                ),
                const SizedBox(height: 12),
                _FinanceRow(
                  title: 'Taxes & Fees',
                  value: _formatCurrency(taxesFees),
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.white.withOpacity(.15)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL BALANCE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(.7),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      _formatCurrency(totalBalance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceRow extends StatelessWidget {
  final String title;
  final String value;

  const _FinanceRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white.withOpacity(.7), fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
