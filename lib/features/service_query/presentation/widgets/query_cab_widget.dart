import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../state/cab_query_state.dart';

class CabQueryWidget extends ConsumerWidget {
  const CabQueryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cabQueryState = ref.watch(cabQueryControllerProvider);
    final cabQueryNotifier = ref.read(cabQueryControllerProvider.notifier);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => cabQueryNotifier.queryCabs(),
          child: const Text('Query Cabs'),
        ),
        _buildBody(cabQueryState),
      ],
    );
  }

  Widget _buildBody(CabQueryState state) {
    if (state is CabQueryInitial) {
      return const Center(child: Text('Press button to query cabs'));
    } else if (state is CabQueryLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CabQueryLoaded) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.cabs.length,
        itemBuilder: (context, index) {
          final cab = state.cabs[index];
          return ListTile(
            title: Text(cab.name),
            subtitle: Text('${cab.vehicleType} - ${cab.vehicleNumber}'),
          );
        },
      );
    } else if (state is CabQueryError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    return const SizedBox();
  }
}
