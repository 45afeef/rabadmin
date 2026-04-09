import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.green.shade900],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          /// 🧭 HEADER
          Row(
            children: const [
              Icon(Icons.tune, color: Colors.greenAccent),
              SizedBox(width: 8),
              Text(
                "Driver Control Panel",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔹 QUICK SEARCH PANEL
          _buildPanel(
            child: Column(
              children: [
                _inputField(
                  icon: Icons.location_on,
                  hint: "Search location",
                  onChanged: (v) => location = v,
                ),
                const SizedBox(height: 10),
                _inputField(
                  icon: Icons.people,
                  hint: "Minimum capacity",
                  isNumber: true,
                  onChanged: (v) => minCapacity = int.tryParse(v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// 🔽 ADVANCED TOGGLE (PILL STYLE)
          GestureDetector(
            onTap: () => setState(() => showAdvanced = !showAdvanced),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.greenAccent),
              ),
              child: Center(
                child: Text(
                  showAdvanced
                      ? "Hide Advanced Controls"
                      : "Show Advanced Controls",
                  style: const TextStyle(color: Colors.greenAccent),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// 🧠 ADVANCED PANEL
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: showAdvanced
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: _buildPanel(
              child: Column(
                children: [
                  /// Radius
                  Row(
                    children: [
                      const Text(
                        "Radius",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: Colors.greenAccent,
                          value: radiusKm,
                          min: 0.1,
                          max: 50,
                          onChanged: (v) => setState(() => radiusKm = v),
                        ),
                      ),
                      Text(
                        "${radiusKm.toStringAsFixed(1)} km",
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

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

          /// 🚀 SEARCH BUTTON (GLOW STYLE)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: state is DriverQueryLoading ? null : _performQuery,
              child: const Text("Find Drivers"),
            ),
          ),

          const SizedBox(height: 16),

          /// 📊 RESULTS PANEL
          _buildBody(state),
        ],
      ),
    );
  }

  /// 🧱 PANEL CONTAINER
  Widget _buildPanel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.4)),
      ),
      child: child,
    );
  }

  /// 🔤 INPUT STYLE
  Widget _inputField({
    IconData? icon,
    required String hint,
    bool isNumber = false,
    required Function(String) onChanged,
  }) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.greenAccent) : null,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.black54,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }

  /// 📊 RESULTS
  Widget _buildBody(DriverQueryState state) {
    if (state is DriverQueryInitial) {
      return const Center(
        child: Text(
          'Run a query to see drivers',
          style: TextStyle(color: Colors.white54),
        ),
      );
    } else if (state is DriverQueryLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.greenAccent),
      );
    } else if (state is DriverQueryLoaded) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.drivers.length,
        itemBuilder: (context, index) {
          final d = state.drivers[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.greenAccent.withValues(alpha: 0.3),
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.greenAccent),
              title: Text(
                d.fullName ??
                    ((d.firstName?.isNotEmpty == true ||
                            d.lastName?.isNotEmpty == true)
                        ? '${d.firstName ?? ''} ${d.lastName ?? ''}'.trim()
                        : 'Driver ${d.id}'),
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Provider: ${d.providerId}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  if (d.primaryPhoneNumber != null)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Phone: ${d.primaryPhoneNumber}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.call,
                            color: Colors.greenAccent,
                            size: 20,
                          ),
                          onPressed: () => launchUrl(
                            Uri.parse('tel:${d.primaryPhoneNumber}'),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Call',
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.chat,
                            color: Colors.green,
                            size: 20,
                          ),
                          onPressed: () => launchUrl(
                            Uri.parse(
                              'https://wa.me/${d.primaryPhoneNumber!.replaceAll(RegExp(r'[^\d]'), '')}',
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'WhatsApp',
                        ),
                      ],
                    ),
                  if (d.secondaryPhoneNumber != null)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Secondary Phone: ${d.secondaryPhoneNumber}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.call,
                            color: Colors.greenAccent,
                            size: 20,
                          ),
                          onPressed: () => launchUrl(
                            Uri.parse('tel:${d.secondaryPhoneNumber}'),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Call',
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.chat,
                            color: Colors.green,
                            size: 20,
                          ),
                          onPressed: () => launchUrl(
                            Uri.parse(
                              'https://wa.me/${d.secondaryPhoneNumber!.replaceAll(RegExp(r'[^\d]'), '')}',
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'WhatsApp',
                        ),
                      ],
                    ),
                  if (d.primaryEmail != null)
                    InkWell(
                      onTap: () =>
                          launchUrl(Uri.parse('mailto:${d.primaryEmail}')),
                      child: Text(
                        'Email: ${d.primaryEmail}',
                        style: const TextStyle(
                          color: Colors.white70,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  if (d.secondaryEmail != null)
                    InkWell(
                      onTap: () =>
                          launchUrl(Uri.parse('mailto:${d.secondaryEmail}')),
                      child: Text(
                        'Secondary Email: ${d.secondaryEmail}',
                        style: const TextStyle(
                          color: Colors.white70,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            ),
          );
        },
      );
    } else if (state is DriverQueryError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }
    return const SizedBox();
  }
}
