import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String location;
  final String commission;
  final String description;
  final String image;
  final List<String> tags;

  const ServiceCard({
    super.key,
    required this.title,
    required this.location,
    required this.commission,
    required this.description,
    required this.image,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                image,
                width: 240,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(location),

                  const SizedBox(height: 12),

                  Text(description),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    children: tags.map((e) => Chip(label: Text(e))).toList(),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Commission $commission",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("View Details"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
