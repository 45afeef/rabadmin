import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../service_providers/domain/entities/cab_entity.dart';
import '../state/cab_query_state.dart';

class CabQueryWidget extends ConsumerStatefulWidget {
  final void Function(CabEntity cab)? onCabSelected;

  const CabQueryWidget({super.key, this.onCabSelected});

  @override
  ConsumerState<CabQueryWidget> createState() => _CabQueryWidgetState();
}

class _CabQueryWidgetState extends ConsumerState<CabQueryWidget> {
  final _locationController = TextEditingController();

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

    final isLocationValid = location != null && location!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 📍 LOCATION
        TextField(
          controller: _locationController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: "Pickup location",
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (v) => location = v.trim(),
        ),

        const SizedBox(height: 16),

        /// 🚘 VEHICLE TYPE
        const Text(
          "Select Vehicle Type",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 10),

        _buildChips(vehicleTypes, accent),

        const SizedBox(height: 16),

        /// 👥 CAPACITY + ⚙️ TOGGLE
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.people),
                  hintText: "Minimum passengers",
                  filled: true,
                  fillColor: Colors.black.withValues(alpha: 0.18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => minCapacity = int.tryParse(v),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => setState(() => showAdvanced = !showAdvanced),
              child: _pill(
                icon: Icons.tune,
                text: "Filters",
                isActive: showAdvanced,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

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
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: "Provider ID (optional)",
                  filled: true,
                  fillColor: Colors.black.withValues(alpha: 0.18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
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

        /// 🚀 SEARCH BUTTON
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: state is CabQueryLoading ? null : _performQuery,
            child: state is CabQueryLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    "Find Cabs",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
          ),
        ),

        const SizedBox(height: 20),

        _buildBody(state),
      ],
    );
  }

  Widget _pill({
    required IconData icon,
    required String text,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips(List<String> items, Color accent) {
    return Wrap(
      spacing: 4,
      runSpacing: 3,
      children: items.map((item) {
        final selected = vehicleType == item;

        return ChoiceChip(
          label: Text(
            item,
            style: TextStyle(
              color: selected ? accent : Colors.black87,
              fontSize: 10,
              fontWeight: selected ? FontWeight.bold : FontWeight.w200,
            ),
          ),
          side: BorderSide(color: Colors.transparent),
          selected: selected,
          backgroundColor: const Color.fromARGB(102, 254, 8, 0),
          selectedColor: Colors.white,
          onSelected: (_) {
            setState(() {
              vehicleType = selected ? null : item;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildBody(CabQueryState state) {
    if (state is CabQueryLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CabQueryLoaded) {
      if (state.cabs.isEmpty) {
        return Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.white54),
              const SizedBox(height: 10),
              const Text(
                "No cabs found",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Try changing filters or location",
                style: TextStyle(color: Colors.black.withValues(alpha: 0.7)),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.cabs.length,
        itemBuilder: (context, index) {
          final cab = state.cabs[index];

          return InkWell(
            onTap: () => widget.onCabSelected?.call(cab),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cab.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${cab.vehicleType} • ${cab.capacity} pax",
                        style: const TextStyle(color: Colors.black54),
                      ),
                      Text(
                        "₹${cab.minimumRate}",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (state is CabQueryError) {
      return Text(state.message);
    }

    return const SizedBox();
  }
}
