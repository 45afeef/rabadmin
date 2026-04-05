import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../state/driver_query_state.dart';

class DriverQueryWidget extends ConsumerStatefulWidget {
  const DriverQueryWidget({super.key});

  @override
  ConsumerState<DriverQueryWidget> createState() => _DriverQueryWidgetState();
}

class _DriverQueryWidgetState extends ConsumerState<DriverQueryWidget> {
  bool showAdvanced = false;

  String? providerId;
  String? location;
  double radiusKm = 5.0;
  int? minCapacity;

  void _performQuery() {
    ref
        .read(driverQueryControllerProvider.notifier)
        .queryDrivers(
          providerId: providerId?.isEmpty ?? true ? null : providerId,
          radiusKm: radiusKm,
          minCapacity: minCapacity,
        );
  }

  @override
  Widget build(BuildContext context) {
    final driverQueryState = ref.watch(driverQueryControllerProvider);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// 🔹 PRIMARY ROW - Location and Capacity
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                hintText: "Search location",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => location = value.isEmpty ? null : value,
            ),
            const SizedBox(height: 10),

            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.people),
                hintText: "Minimum capacity needed",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => minCapacity = int.tryParse(value),
            ),

            const SizedBox(height: 10),

            /// 🔽 ADVANCED FILTERS
            if (showAdvanced) ...[
              const Divider(),

              /// Radius slider
              Row(
                children: [
                  const Text("Search Radius:"),
                  Expanded(
                    child: Slider(
                      value: radiusKm,
                      min: 0.1,
                      max: 50.0,
                      divisions: 50,
                      label: "${radiusKm.toStringAsFixed(1)} km",
                      onChanged: (value) => setState(() => radiusKm = value),
                    ),
                  ),
                  Text("${radiusKm.toStringAsFixed(1)} km"),
                ],
              ),

              const Divider(),

              /// Provider ID
              TextField(
                decoration: const InputDecoration(
                  labelText: "Provider ID (Optional)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => providerId = value.isEmpty ? null : value,
              ),
            ],

            const SizedBox(height: 10),

            /// Toggle Advanced Filters
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => setState(() => showAdvanced = !showAdvanced),
                child: Text(
                  showAdvanced ? "Hide Filters" : "Show More Filters",
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// 🔍 SEARCH BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _performQuery,
                child: const Text("Search Drivers"),
              ),
            ),

            /// RESULTS
            _buildBody(driverQueryState),
          ],
        ),
      ),
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
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              title: Text('Driver ${driver.id}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile: ${driver.profileId}'),
                  if (driver.userId != null) Text('User ID: ${driver.userId}'),
                  Text('Provider: ${driver.providerId}'),
                ],
              ),
              trailing: const Icon(Icons.phone),
            ),
          );
        },
      );
    } else if (state is DriverQueryError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    return const SizedBox();
  }
}
