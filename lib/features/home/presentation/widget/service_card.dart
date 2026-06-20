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
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;

            final imageSection = ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                image,
                width: double.infinity,
                height: isMobile ? 220 : 180,
                fit: BoxFit.cover,
              ),
            );

            final contentSection = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(location),

                const SizedBox(height: 12),

                Text(
                  description,
                  maxLines: isMobile ? null : 4,
                  overflow: isMobile
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((e) => Chip(label: Text(e))).toList(),
                ),

                const SizedBox(height: 16),

                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Commission $commission",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("View Details"),
                            ),
                          ),
                        ],
                      )
                    : Row(
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
            );

            return isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageSection,
                      const SizedBox(height: 16),
                      contentSection,
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 240, child: imageSection),

                      const SizedBox(width: 20),

                      Expanded(child: contentSection),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
