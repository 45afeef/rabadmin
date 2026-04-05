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
  bool showAdvanced = false;
  bool splitGender = false;

  int adults = 2;
  int kids = 0;
  int men = 0;
  int women = 0;
  int rooms = 1;

  Set<String> selectedFilters = {};

  String? location;
  DateTime? checkIn;
  DateTime? checkOut;
  int? maxRate;

  final List<String> popular = ["Pool", "WiFi", "Hot Water"];
  final List<String> nature = ["Near Forest", "Natural Pool", "Trekking"];
  final List<String> special = ["Event Friendly", "Dormitory", "Tent"];
  final List<String> vibe = ["Quiet", "Adventure", "Luxury", "Budget"];

  Widget buildChips(List<String> items) {
    return Wrap(
      spacing: 8,
      children: items.map((item) {
        final selected = selectedFilters.contains(item);
        return FilterChip(
          label: Text(item),
          selected: selected,
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

  Widget stepper(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
            ),
            Text(value.toString()),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }

  void _performQuery() {
    ref
        .read(stayProviderQueryControllerProvider.notifier)
        .queryStayProviders(
          location: location,
          checkIn: checkIn,
          checkOut: checkOut,
          pax: adults + kids,
          maxRate: maxRate,
          amenities: selectedFilters.toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stayProviderQueryControllerProvider);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            /// 🔹 PRIMARY ROW
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                hintText: "Where are you going?",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => location = value.isEmpty ? null : value,
            ),
            SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: "Dates",
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          checkIn = picked.start;
                          checkOut = picked.end;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: checkIn != null && checkOut != null
                          ? '${checkIn!.toLocal().toString().split(' ')[0]} - ${checkOut!.toLocal().toString().split(' ')[0]}'
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => showAdvanced = !showAdvanced),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text("$adults Adults, $kids Kids"),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            /// 🔽 ADVANCED FILTERS
            if (showAdvanced) ...[
              Divider(),

              /// Guests
              stepper("Adults", adults, (v) => setState(() => adults = v)),
              stepper("Kids", kids, (v) => setState(() => kids = v)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Split by Gender"),
                  Switch(
                    value: splitGender,
                    onChanged: (v) => setState(() => splitGender = v),
                  ),
                ],
              ),

              if (splitGender) ...[
                stepper("Men", men, (v) => setState(() => men = v)),
                stepper("Women", women, (v) => setState(() => women = v)),
              ],

              Divider(),

              /// Rooms
              stepper("Rooms", rooms, (v) => setState(() => rooms = v)),

              Divider(),

              /// Max Rate
              TextField(
                decoration: InputDecoration(
                  labelText: "Max Rate",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => maxRate = int.tryParse(value),
              ),

              Divider(),

              /// Filters
              Align(alignment: Alignment.centerLeft, child: Text("Popular")),
              buildChips(popular),

              Align(alignment: Alignment.centerLeft, child: Text("Nature")),
              buildChips(nature),

              Align(alignment: Alignment.centerLeft, child: Text("Special")),
              buildChips(special),

              Align(alignment: Alignment.centerLeft, child: Text("Vibe")),
              buildChips(vibe),
            ],

            SizedBox(height: 10),

            /// 🔍 SEARCH BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _performQuery,
                child: Text("Search"),
              ),
            ),

            /// RESULTS
            if (state is StayProviderQueryLoading) ...[
              CircularProgressIndicator(),
            ] else if (state is StayProviderQueryLoaded) ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.providers.length,
                itemBuilder: (context, index) {
                  final provider = state.providers[index];
                  return ListTile(
                    title: Text(provider.name),
                    subtitle: Text(
                      '${provider.propertyType} : ${provider.optimalOccupancy}-${provider.maxOccupancy} pax',
                    ),
                    trailing: Text('${provider.roomCount} rooms'),
                  );
                },
              ),
            ] else if (state is StayProviderQueryError) ...[
              Text('Error: ${state.message}'),
            ],
          ],
        ),
      ),
    );
  }
}
