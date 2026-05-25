import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/providers/providers.dart';
import '../../../service_providers/domain/entities/driver_entity.dart';
import '../state/driver_query_state.dart';

class DriverQueryWidget extends ConsumerStatefulWidget {
  final void Function(DriverEntity driver)? onDriverSelected;

  const DriverQueryWidget({super.key, this.onDriverSelected});

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
    FocusScope.of(context).unfocus();

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
    final state = ref.watch(driverQueryControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        Row(
          children: const [
            Icon(Icons.tune, size: 20, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              "Driver Search",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// SEARCH CARD
        _card(
          child: Column(
            children: [
              _inputField(
                icon: Icons.location_on_outlined,
                hint: "Location",
                onChanged: (v) => location = v,
              ),
              const SizedBox(height: 12),
              _inputField(
                icon: Icons.people_outline,
                hint: "Minimum capacity",
                isNumber: true,
                onChanged: (v) => minCapacity = int.tryParse(v),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        /// ADVANCED TOGGLE
        TextButton(
          onPressed: () => setState(() => showAdvanced = !showAdvanced),
          child: Text(
            showAdvanced ? "Hide advanced" : "Show advanced",
            style: const TextStyle(color: Colors.blueGrey),
          ),
        ),

        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: showAdvanced
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Radius
                const Text(
                  "Search Radius",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        activeColor: Colors.grey.shade800,
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

                const SizedBox(height: 12),

                _inputField(
                  hint: "Provider ID (optional)",
                  onChanged: (v) => providerId = v,
                ),
              ],
            ),
          ),
          secondChild: const SizedBox(),
        ),

        const SizedBox(height: 16),

        /// SEARCH BUTTON
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state is DriverQueryLoading ? null : _performQuery,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.greenAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state is DriverQueryLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text("Search Drivers", style: TextStyle(fontSize: 16)),
          ),
        ),

        const SizedBox(height: 20),

        /// RESULTS
        _buildBody(state),
      ],
    );
  }

  /// CARD CONTAINER
  Widget _card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  // INPUT FIELD
  Widget _inputField({
    IconData? icon,
    required String hint,
    bool isNumber = false,
    required Function(String) onChanged,
  }) {
    return TextField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.18),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }

  /// RESULTS
  Widget _buildBody(DriverQueryState state) {
    if (state is DriverQueryInitial) {
      return const Center(child: Text('Start searching for drivers'));
    }

    if (state is DriverQueryError) {
      return Center(
        child: Text(state.message, style: const TextStyle(color: Colors.red)),
      );
    }

    if (state is DriverQueryLoaded) {
      if (state.drivers.isEmpty) {
        return const Center(child: Text('No drivers found'));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.drivers.length,
        itemBuilder: (context, index) {
          final d = state.drivers[index];

          final name =
              d.fullName ?? '${d.firstName ?? ''} ${d.lastName ?? ''}'.trim();

          return GestureDetector(
            onTap: () => widget.onDriverSelected?.call(d),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade100,
                  child: const Icon(Icons.person, color: Colors.black54),
                ),
                title: Text(name.isEmpty ? 'Driver ${d.id}' : name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (d.primaryPhoneNumber != null)
                      _contactRow(d.primaryPhoneNumber!),
                    if (d.secondaryPhoneNumber != null)
                      _contactRow(d.secondaryPhoneNumber!),
                    if (d.primaryEmail != null) _emailRow(d.primaryEmail!),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return const SizedBox();
  }

  Widget _contactRow(String phone) {
    final clean = phone.replaceAll(RegExp(r'[^\d]'), '');

    return Row(
      children: [
        Expanded(child: Text(phone)),
        IconButton(
          icon: const Icon(Icons.call, size: 18),
          onPressed: () => launchUrl(Uri.parse('tel:$phone')),
        ),
        IconButton(
          icon: const Icon(Icons.chat_rounded, size: 18),
          onPressed: () => launchUrl(Uri.parse('https://wa.me/$clean')),
        ),
      ],
    );
  }

  Widget _emailRow(String email) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse('mailto:$email')),
      child: Text(
        email,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
