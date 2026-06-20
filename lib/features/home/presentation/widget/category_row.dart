// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({super.key});

  static const _categories = [
    {
      'title': 'Premium Accommodations',
      'subtitle': '5,400+ Vetted Hotels',
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
    },
    {
      'title': 'VIP Logistics',
      'subtitle': 'Private Transfers',
      'image': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
    },
    {
      'title': 'Curated Tours',
      'subtitle': 'Local Experiences',
      'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final visibleItems = constraints.maxWidth < 800 ? 1.5 : 3.5;
        const HORIZONTALPADDING = 24.0;
        const SPACING = 16.0;
        final itemWidth =
            (constraints.maxWidth - HORIZONTALPADDING * 2) / visibleItems;
        final itemHeight = itemWidth / 1.6;

        return SizedBox(
          height: itemHeight,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: SPACING),
            itemBuilder: (context, index) {
              final category = _categories[index];
              return SizedBox(
                width: itemWidth,
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: CategoryCard(
                    title: category['title']!,
                    subtitle: category['subtitle']!,
                    image: category['image']!,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Positioned.fill(child: Image.network(image, fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(.75), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Text(subtitle, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
