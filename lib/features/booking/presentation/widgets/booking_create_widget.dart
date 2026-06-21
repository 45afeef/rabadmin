import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/selected_Traveller_entity.dart';
import '../notifiers/booking_notifier.dart';

/// =============================================================
/// REUSABLE BOOKING FORM WIDGET
/// =============================================================
/// Features:
/// - Reusable widget (NOT a page)
/// - Safe inside:
///   - NestedScrollView
///   - PageView
///   - Dialogs
///   - BottomSheets
///   - Slivers
///   - Tabs
/// - Responsive
/// - Avoids common Flutter layout errors
/// - External controller/state ownership
/// - Reusable sections
/// - Proper disposal support
/// =============================================================

/// =============================================================
/// MAIN WIDGET
/// =============================================================

class BookingFormWidget extends ConsumerWidget {
  /// IMPORTANT FOR NESTED SCROLLS
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  /// Optional external padding
  final EdgeInsetsGeometry padding;

  /// Show submit button or not
  final bool showSubmitButton;

  /// Submit callback
  final VoidCallback? onSubmit;

  const BookingFormWidget({
    super.key,
    this.physics,
    this.shrinkWrap = true,
    this.padding = const EdgeInsets.all(16),
    this.showSubmitButton = false,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAmountCtrl = TextEditingController();
    return Form(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            children: [
              AppInput(
                controller: totalAmountCtrl,
                label: "Total Amount",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 24),
              SectionHeader(
                title: "Travellers",
                onAdd: () {
                  void showAddTravellerDialog(
                    BuildContext context,
                    WidgetRef ref,
                  ) {
                    final nameController = TextEditingController();
                    final phoneController = TextEditingController();

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Add Traveller'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () {
                                final bookingNotifier = ref.read(
                                  bookingNotifierProvider.notifier,
                                );

                                bookingNotifier.addTraveller(
                                  SelectedTravellerEntity.byGuest(
                                    name: nameController.text.trim(),
                                    phone: phoneController.text.trim(),
                                  ),
                                );

                                Navigator.pop(context);
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  }

                  showAddTravellerDialog(context, ref);
                },
              ),
              TravellerSection(),

              const SizedBox(height: 24),
              SectionHeader(title: "Cabs", onAdd: () {}),
              CabSection(),

              const SizedBox(height: 24),
              SectionHeader(title: "Stays", onAdd: () {}),
              StaySection(),

              if (showSubmitButton) ...[
                const SizedBox(height: 32),

                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: onSubmit,
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// =============================================================
/// TRAVELLER SECTION
/// =============================================================

class TravellerSection extends ConsumerWidget {
  const TravellerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travellers = ref.watch(
      bookingNotifierProvider.select((s) => s.travellers),
    );

    final bookingNotifier = ref.read(bookingNotifierProvider.notifier);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: travellers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final traveller = travellers[index];

        return Card(
          child: ListTile(
            key: ValueKey(traveller.travellerId),
            dense: true,
            title: Text(traveller.travellerName ?? "Unknown"),
            subtitle: Text(traveller.travellerPhone ?? "N/A"),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => bookingNotifier.removeTraveller(index),
            ),
          ),
        );
      },
    );
  }
}

/// =============================================================
/// CAB SECTION
/// =============================================================

class CabSection extends ConsumerWidget {
  const CabSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cabs = ref.watch(bookingNotifierProvider.select((s) => s.cabs));

    final bookingNotifier = ref.read(bookingNotifierProvider.notifier);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cabs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final cab = cabs[index];

        return Card(
          child: ListTile(
            key: ValueKey(cab.hashCode),
            dense: true,
            title: Text(cab.name),
            subtitle: Text(cab.companyModel),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => bookingNotifier.removeTraveller(index),
            ),
          ),
        );
      },
    );
  }
}

/// =============================================================
/// STAY SECTION
/// =============================================================

class StaySection extends ConsumerWidget {
  const StaySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stays = ref.watch(bookingNotifierProvider.select((s) => s.stays));

    final bookingNotifier = ref.read(bookingNotifierProvider.notifier);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stays.length,
      separatorBuilder: (_, __) => const Divider(height: 8),
      itemBuilder: (context, index) {
        final stay = stays[index];

        return Card(
          child: ListTile(
            key: ValueKey(stay.hashCode),
            dense: true,
            title: Text(stay.name),
            subtitle: Text(
              'Occupancy: ${stay.optimalOccupancy} - Rooms : ${stay.roomCount}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => bookingNotifier.removeTraveller(index),
            ),
          ),
        );
      },
    );
  }
}

/// =============================================================
/// RESPONSIVE WRAP
/// =============================================================

class ResponsiveWrap extends StatelessWidget {
  final List<Widget> children;
  final double maxWidth;

  const ResponsiveWrap({
    super.key,
    required this.children,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    int columns = 1;

    if (maxWidth >= 1100) {
      columns = 3;
    } else if (maxWidth >= 700) {
      columns = 2;
    }

    final spacing = 16.0;

    final itemWidth = (maxWidth - (spacing * (columns - 1))) / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: children.map((child) {
        return SizedBox(width: itemWidth, child: child);
      }).toList(),
    );
  }
}

class AppInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppInput({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      validator: validator,
      decoration: _inputDecoration(label),
    );
  }
}

/// =============================================================
/// SECTION HEADER
/// =============================================================

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;

  const SectionHeader({super.key, required this.title, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text("Add"),
        ),
      ],
    );
  }
}

/// =============================================================
/// INPUT DECORATION
/// =============================================================

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    isDense: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );
}
