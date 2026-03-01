import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/providers.dart';

/// Displays all stay service providers and allows navigation to details or
/// creation of a new provider.
class StayProvidersListPage extends ConsumerWidget {
  const StayProvidersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stayProvidersAsync = ref.watch(stayProvidersListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stay Providers')),
      body: stayProvidersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (providers) {
          if (providers.isEmpty) {
            return const Center(child: Text('No stay providers found'));
          }
          return ListView.builder(
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final prov = providers[index];
              return ListTile(
                title: Text(prov.name ?? 'Unnamed provider'),
                subtitle: Text('id: ${prov.id}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/service-providers/stay/${prov.id}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/service-providers/stay/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
