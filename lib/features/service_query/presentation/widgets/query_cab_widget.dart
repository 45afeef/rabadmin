import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../state/cab_query_state.dart';

class CabQueryWidget extends ConsumerStatefulWidget {
  const CabQueryWidget({super.key});

  @override
  ConsumerState<CabQueryWidget> createState() => _CabQueryWidgetState();
}

class _CabQueryWidgetState extends ConsumerState<CabQueryWidget> {
  bool showAdvanced = false;

  String? providerId;
  String? vehicleType;
  String? location;
  double radiusKm = 5.0;
  int? minCapacity;
  int? maxCapacity;
  int? minMinimumRate;
  int? maxMinimumRate;
  int? minPerKmRate;
  int? maxPerKmRate;
  int? minKmForMinimumRate;
  int? maxKmForMinimumRate;

  final List<String> vehicleTypes = ["SEDAN", "SUV", "HATCHBACK", "VAN"];

  Widget buildChips(List<String> items) {
    return Wrap(
      spacing: 8,
      children: items.map((item) {
        final selected = vehicleType == item;
        return FilterChip(
          label: Text(item),
          selected: selected,
          onSelected: (_) {
            setState(() {
              vehicleType = selected ? null : item;
            });
          },
        );
      }).toList(),
    );
  }

  void _performQuery() {
    ref
        .read(cabQueryControllerProvider.notifier)
        .queryCabs(
          providerId: providerId?.isEmpty ?? true ? null : providerId,
          vehicleType: vehicleType,
          radiusKm: radiusKm,
          minCapacity: minCapacity,
          maxCapacity: maxCapacity,
          minMinimumRate: minMinimumRate,
          maxMinimumRate: maxMinimumRate,
          minPerKmRate: minPerKmRate,
          maxPerKmRate: maxPerKmRate,
          minKmForMinimumRate: minKmForMinimumRate,
          maxKmForMinimumRate: maxKmForMinimumRate,
        );
  }

  @override
  Widget build(BuildContext context) {
    final cabQueryState = ref.watch(cabQueryControllerProvider);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// 🔹 PRIMARY ROW - Location and Vehicle Type
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                hintText: "Pickup location",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => location = value.isEmpty ? null : value,
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.directions_car),
                      hintText: "Vehicle Type",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: vehicleType,
                    items: vehicleTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) => setState(() => vehicleType = value),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.people),
                      hintText: "Min Capacity",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => minCapacity = int.tryParse(value),
                  ),
                ),
              ],
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

              /// Rate filters
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Rate Filters"),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Min Base Rate",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          minMinimumRate = int.tryParse(value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Max Base Rate",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          maxMinimumRate = int.tryParse(value),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Min Per Km Rate",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => minPerKmRate = int.tryParse(value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Max Per Km Rate",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => maxPerKmRate = int.tryParse(value),
                    ),
                  ),
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
                child: const Text("Search Cabs"),
              ),
            ),

            /// RESULTS
            _buildBody(cabQueryState),
          ],
        ),
      ),
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
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.directions_car, color: Colors.blue),
              title: Text('${cab.name} - ${cab.vehicleType}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Number: ${cab.vehicleNumber}'),
                  Text('Capacity: ${cab.capacity} passengers'),
                  Text(
                    'Base Rate: ₹${cab.minimumRate} (${cab.kmForMinimumRate}km)',
                  ),
                  Text('Per Km: ₹${cab.perKmRate}'),
                  Text('Color: ${cab.color}'),
                ],
              ),
              trailing: Text('₹${cab.minimumRate}'),
            ),
          );
        },
      );
    } else if (state is CabQueryError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    return const SizedBox();
  }
}
