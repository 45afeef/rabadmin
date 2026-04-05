import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../state/driver_query_state.dart';

class DriverQueryWidget extends ConsumerWidget {
  const DriverQueryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverQueryState = ref.watch(driverQueryControllerProvider);
    final driverQueryNotifier = ref.read(
      driverQueryControllerProvider.notifier,
    );

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => driverQueryNotifier.queryDrivers(),
          child: const Text('Query Drivers'),
        ),
        _buildBody(driverQueryState),
      ],
    );
  }

  Widget _buildBody(DriverQueryState state) {
    if (state is DriverQueryInitial) {
      return const Center(child: Text('Press button to query drivers'));
    } else if (state is DriverQueryLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is DriverQueryLoaded) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.drivers.length,
        itemBuilder: (context, index) {
          final driver = state.drivers[index];
          return ListTile(
            title: Text('Driver ${driver.id}'),
            subtitle: Text('Profile: ${driver.profileId}'),
          );
        },
      );
    } else if (state is DriverQueryError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    return const SizedBox();
  }
}
