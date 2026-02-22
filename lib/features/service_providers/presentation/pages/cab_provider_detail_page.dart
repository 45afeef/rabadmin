import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shows details for a particular cab service provider, including lists of
/// cabs and drivers and buttons to create new ones.
class CabProviderDetailPage extends ConsumerWidget {
  final String providerId;

  const CabProviderDetailPage({required this.providerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Provider $providerId')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ExpansionTile(
            title: const Text('Cabs'),
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add Cab'),
                onTap: () => context.push(
                  '/service-providers/cab/$providerId/cabs/create',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Drivers'),
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add Driver'),
                onTap: () => context.push(
                  '/service-providers/cab/$providerId/drivers/create',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
