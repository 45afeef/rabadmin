import 'package:flutter/material.dart';

class FiltersPanel extends StatelessWidget {
  const FiltersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Price Range",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        Slider(value: 3000, min: 200, max: 5000, onChanged: (_) {}),

        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("\$200"), Text("\$5,000+")],
        ),

        const SizedBox(height: 32),

        _sectionTitle("Service Type"),

        _checkItem("Boutique Hotels", false),

        _checkItem("Luxury Resorts", true),

        _checkItem("Private Villas", false),

        const SizedBox(height: 24),

        _sectionTitle("Pax Count"),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(child: _pillButton("1-2")),
            const SizedBox(width: 8),
            Expanded(child: _pillButton("3-4", selected: true)),
            const SizedBox(width: 8),
            Expanded(child: _pillButton("5+")),
          ],
        ),

        const SizedBox(height: 24),

        _sectionTitle("Room Type"),

        _checkItem("Deluxe Room", false),
        _checkItem("Executive Suite", false),
        _checkItem("Presidential Villa", false),

        const SizedBox(height: 24),

        _sectionTitle("Amenities"),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _amenity("WiFi"),
            _amenity("Spa"),
            _amenity("Pool"),
            _amenity("Gym"),
          ],
        ),

        const SizedBox(height: 32),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF003366),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.workspace_premium, color: Colors.white),

              const SizedBox(height: 12),

              const Text(
                "Agent Exclusive",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Unlock 15% higher commissions on all Signature Series properties listed this month.",
                style: TextStyle(color: Colors.white70, height: 1.5),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Learn More"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget _checkItem(String text, bool selected) {
    return CheckboxListTile(
      value: selected,
      onChanged: (_) {},
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(text),
    );
  }

  static Widget _pillButton(String text, {bool selected = false}) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF001E40) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _amenity(String label) {
    return FilterChip(label: Text(label), selected: false, onSelected: (_) {});
  }
}
