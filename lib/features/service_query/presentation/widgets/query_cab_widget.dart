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

  final List<String> vehicleTypes = ["SEDAN", "SUV", "HATCHBACK", "VAN"];

  void _performQuery() {
    FocusScope.of(context).unfocus();

    ref
        .read(cabQueryControllerProvider.notifier)
        .queryCabs(
          providerId: providerId?.isEmpty ?? true ? null : providerId,
          vehicleType: vehicleType,
          radiusKm: radiusKm,
          minCapacity: minCapacity,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cabQueryControllerProvider);

    const accent = Color(0xFFFF7A00);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 📍 LOCATION INPUT
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.location_on),
            hintText: "Pickup location",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (v) => location = v,
        ),

        const SizedBox(height: 16),

        /// 🚘 VEHICLE TYPE (CHIPS UI)
        const Text(
          "Select Vehicle Type",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 10,
          children: vehicleTypes.map((type) {
            final selected = vehicleType == type;
            return ChoiceChip(
              label: Text(
                type,
                style: TextStyle(
                  color: selected ? accent : Colors.black87,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w200,
                  fontSize: 10,
                ),
              ),
              selected: selected,
              selectedColor: accent,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black87,
              ),
              onSelected: (_) {
                setState(() {
                  vehicleType = selected ? null : type;
                });
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        /// 👥 CAPACITY
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.people),
            hintText: "Minimum passengers",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: (v) => minCapacity = int.tryParse(v),
        ),

        const SizedBox(height: 12),

        /// ⚙️ FILTER TOGGLE (LIGHT STYLE)
        TextButton.icon(
          onPressed: () => setState(() => showAdvanced = !showAdvanced),
          icon: Icon(
            showAdvanced ? Icons.expand_less : Icons.tune,
            color: Colors.black,
          ),
          label: Text(
            showAdvanced ? "Hide filters" : "More filters",
            style: TextStyle(color: Colors.black),
          ),
        ),

        /// ⚙️ ADVANCED (LIGHT PANEL STYLE)
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: showAdvanced
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Column(
            children: [
              Row(
                children: [
                  const Text("Radius"),
                  Expanded(
                    child: Slider(
                      value: radiusKm,
                      activeColor: accent,
                      min: 0.1,
                      max: 50,
                      onChanged: (v) => setState(() => radiusKm = v),
                    ),
                  ),
                  Text("${radiusKm.toStringAsFixed(1)} km"),
                ],
              ),

              TextField(
                decoration: InputDecoration(
                  hintText: "Provider ID (optional)",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (v) => providerId = v,
              ),
            ],
          ),
          secondChild: const SizedBox(),
        ),

        const SizedBox(height: 16),

        /// 🚀 SEARCH BUTTON (RIDE STYLE)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: state is CabQueryLoading ? null : _performQuery,
            child: const Text("Find Cabs", style: TextStyle(fontSize: 16)),
          ),
        ),

        const SizedBox(height: 16),

        _buildBody(state),
      ],
    );
  }

  Widget _buildBody(CabQueryState state) {
    if (state is CabQueryInitial) {
      return const Center(child: Text('Start searching for rides'));
    } else if (state is CabQueryLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CabQueryLoaded) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.cabs.length,
        itemBuilder: (context, index) {
          final cab = state.cabs[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.directions_car, size: 30),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cab.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${cab.vehicleType} • ${cab.capacity} pax",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                Text(
                  "₹${cab.minimumRate}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      );
    } else if (state is CabQueryError) {
      return Text('Error: ${state.message}');
    }
    return const SizedBox();
  }
}
