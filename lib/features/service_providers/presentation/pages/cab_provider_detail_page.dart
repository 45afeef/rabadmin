import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/providers/providers.dart';

/// Shows details for a particular cab service provider, including lists of
/// cabs and drivers and buttons to create new ones.
class CabProviderDetailPage extends ConsumerWidget {
  final String providerId;

  const CabProviderDetailPage({required this.providerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cabsAsync = ref.watch(cabsListProvider(providerId));
    final driversAsync = ref.watch(driversListProvider(providerId));

    return Scaffold(
      appBar: AppBar(title: Text('Provider $providerId')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ExpansionTile(
            title: const Text('Cabs'),
            children: [
              cabsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error loading cabs: $e'),
                ),
                data: (cabs) => Column(
                  children: [
                    for (var cab in cabs)
                      ListTile(
                        title: Text(cab.name),
                        subtitle: Text(
                          '${cab.vehicleType.name} - ${cab.vehicleNumber}',
                        ),
                        leading: Icon(Icons.directions_car),
                        trailing: Text('₹${cab.perKmRate}/km'),
                      ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add Cab'),
                onTap: () => context.push(AppRoutes.createCabPath(providerId)),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Drivers'),
            children: [
              driversAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error loading drivers: $e'),
                ),
                data: (drivers) => Column(
                  children: [
                    for (var d in drivers)
                      ListTile(
                        title: Text(d.userId ?? 'No Associated User'),
                        subtitle: Text(d.profileId),
                      ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add Driver'),
                onTap: () =>
                    context.push(AppRoutes.createDriverPath(providerId)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
