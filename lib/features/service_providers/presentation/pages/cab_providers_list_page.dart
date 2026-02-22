import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/providers/providers.dart';

/// Displays all cab service providers and allows navigation to details or
/// creation of a new provider.
class CabProvidersListPage extends ConsumerWidget {
  const CabProvidersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cabProvidersAsync = ref.watch(cabProvidersListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cab Providers')),
      body: cabProvidersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (providers) {
          if (providers.isEmpty) {
            return const Center(child: Text('No cab providers found'));
          }
          return ListView.builder(
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final prov = providers[index];
              return ListTile(
                title: Text(prov.name),
                subtitle: Text('id: ${prov.id}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    context.push(AppRoutes.cabProviderDetailPath(prov.id)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.createCabProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
