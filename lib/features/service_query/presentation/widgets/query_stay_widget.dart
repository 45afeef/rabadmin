import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../state/stayprovider_query_state.dart';

class StayQueryWidget extends ConsumerStatefulWidget {
  const StayQueryWidget({super.key});

  @override
  ConsumerState<StayQueryWidget> createState() => _StayQueryWidgetState();
}

class _StayQueryWidgetState extends ConsumerState<StayQueryWidget> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();

  bool showAdvanced = false;

  int adults = 0;
  int kids = 0;

  double radiusKm = 5.0;

  Set<String> selectedFilters = {};

  String? location;
  DateTime? checkIn;
  DateTime? checkOut;
  int? roomCount;

  final List<String> popular = ["Pool", "WiFi", "Hot Water"];
  final List<String> nature = ["Near Forest", "Natural Pool", "Trekking"];
  final List<String> special = ["Event Friendly", "Dormitory", "Tent"];
  final List<String> vibe = ["Quiet", "Adventure", "Luxury", "Budget"];

  void _performQuery() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a location")));
      return;
    }

    ref
        .read(stayProviderQueryControllerProvider.notifier)
        .queryStayProviders(
          locationName: location!,
          radiusKm: radiusKm,
          checkIn: checkIn,
          checkOut: checkOut,
          pax: adults + kids,
          amenities: selectedFilters.toList(),
          roomCount: roomCount,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stayProviderQueryControllerProvider);

    const accent = Color(0xFF5A67D8);

    final isLocationValid = location != null && location!.trim().isNotEmpty;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 📍 LOCATION (VALIDATED)
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Where are you going?",
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Location is required";
              }
              return null;
            },
            onChanged: (v) => location = v.trim(),
          ),

          const SizedBox(height: 10),

          const Text(
            "Search Radius",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  activeColor: accent,
                  value: radiusKm,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  label: "${radiusKm.round()} km",
                  onChanged: (v) => setState(() => radiusKm = v),
                ),
              ),
              Text("${radiusKm.toStringAsFixed(0)} km"),
            ],
          ),

          const SizedBox(height: 16),

          /// 📅 DATE + 👨‍👩‍👧 GUESTS
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        checkIn = picked.start;
                        checkOut = picked.end;
                      });
                    }
                  },
                  child: _pill(
                    icon: Icons.calendar_today,
                    text: checkIn != null
                        ? "${checkIn!.day}/${checkIn!.month} - ${checkOut!.day}/${checkOut!.month}"
                        : "Select dates",
                    isActive: checkIn != null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => showAdvanced = !showAdvanced),
                  child: _pill(
                    icon: Icons.people,
                    text: "$adults Adults, $kids Kids",
                    isActive: adults != 0 || kids != 0,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// ⚙️ ADVANCED
          TextButton(
            onPressed: () => setState(() => showAdvanced = !showAdvanced),
            child: const Text("More options"),
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: showAdvanced
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                _stepper("Adults", adults, (v) => setState(() => adults = v)),
                _stepper("Kids", kids, (v) => setState(() => kids = v)),
                _buildChips(special, accent),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Minimum Room Count",
                    hintText: "e.g. 2",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => roomCount = int.tryParse(v),
                ),
              ],
            ),
            secondChild: const SizedBox(),
          ),

          const SizedBox(height: 16),

          /// 🌿 FILTERS
          const Text(
            "What are you looking for?",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 10),

          _buildChips([...popular, ...nature, ...vibe], accent),

          const SizedBox(height: 10),

          /// 🚀 SEARCH BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: state is StayProviderQueryLoading
                  ? null
                  : _performQuery,
              child: state is StayProviderQueryLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Search stays",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          _buildBody(state),
        ],
      ),
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
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
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
        final selected = selectedFilters.contains(item);

        return FilterChip(
          label: Text(
            item,
            style: TextStyle(
              color: selected ? accent : Colors.black87,
              fontSize: 10,
              fontWeight: selected ? FontWeight.bold : FontWeight.w200,
            ),
          ),
          selected: selected,
          backgroundColor: Color.fromARGB(102, 0, 186, 254),
          selectedColor: Colors.white,
          side: BorderSide(
            color: selected ? accent : Colors.transparent,
            width: 1.2,
          ),
          onSelected: (_) {
            setState(() {
              selected
                  ? selectedFilters.remove(item)
                  : selectedFilters.add(item);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _stepper(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
            ),
            Text(value.toString()),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(StayProviderQueryState state) {
    if (state is StayProviderQueryLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is StayProviderQueryLoaded) {
      if (state.providers.isEmpty) {
        return Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48),
              const SizedBox(height: 10),
              const Text(
                "No stays found",
                style: TextStyle(fontWeight: FontWeight.w600),
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
        itemCount: state.providers.length,
        itemBuilder: (context, index) {
          final p = state.providers[index];

          return Container(
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
                  p.name,
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
                      "${p.propertyType} • ${p.optimalOccupancy}-${p.maxOccupancy} pax",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    Text(
                      " ${p.roomCount} rooms",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else if (state is StayProviderQueryError) {
      return Text(state.message);
    }

    return const SizedBox();
  }
}
