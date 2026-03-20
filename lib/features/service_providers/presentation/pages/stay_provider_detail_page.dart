import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/providers.dart';

/// Details for a stay provider with a list of units and ability to add
/// units or amenities.
class StayProviderDetailPage extends ConsumerWidget {
  final String providerId;

  const StayProviderDetailPage({required this.providerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitsAsync = ref.watch(stayUnitsListProvider(providerId));

    return Scaffold(
      appBar: AppBar(title: Text('Stay Provider $providerId')),
      body: Column(
        children: [
          Expanded(
            child: unitsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (units) {
                if (units.isEmpty) {
                  return const Center(child: Text('No stay units found'));
                }
                return ListView.builder(
                  itemCount: units.length,
                  itemBuilder: (context, index) {
                    final u = units[index];
                    return ListTile(
                      title: Text(u.name),
                      subtitle: Text(u.description ?? ''),
                      onTap: () => context.push(
                        '/service-providers/stay/$providerId/units/${u.id}/amenities/add',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('/service-providers/stay/$providerId/units/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
