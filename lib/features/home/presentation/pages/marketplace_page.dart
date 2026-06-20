import 'package:flutter/material.dart';

import '../widget/category_row.dart';
import '../widget/filters_panel.dart';
import '../widget/service_card.dart';

const primary = Color(0xFF001E40);
const secondaryContainer = Color(0xFFD5E3FC);
const background = Color(0xFFF7F9FB);

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'The Executive Concierge',
          style: TextStyle(color: primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
              ),
            ),
          ),
        ],
      ),

      drawer: const _MarketplaceDrawer(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Market"),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge_outlined),
            label: "Team",
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: const [HeroSection(), CategoryRow(), MarketplaceContent()],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 600;

              if (isSmall) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Marketplace",
                      style: TextStyle(
                        color: primary,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text("Add New Service"),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Marketplace",
                      style: TextStyle(
                        color: primary,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text("Add New Service"),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),

          const Text(
            "Discover exclusive partnerships and premium services from our globally vetted network of hotels, private transport, and local tour operators.",
            style: TextStyle(color: Color.fromRGBO(117, 117, 117, 1)),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search destinations, hotels, or services...",
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list),
                        label: const Text("Filters"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Search"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketplaceDrawer extends StatelessWidget {
  const _MarketplaceDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(
            child: Text(
              "Alex Sterling",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(leading: Icon(Icons.dashboard), title: Text("Dashboard")),
          ListTile(leading: Icon(Icons.storefront), title: Text("Marketplace")),
          ListTile(leading: Icon(Icons.event_note), title: Text("Bookings")),
          ListTile(leading: Icon(Icons.chat), title: Text("Messages")),
          ListTile(leading: Icon(Icons.group), title: Text("Staff")),
        ],
      ),
    );
  }
}

class MarketplaceContent extends StatelessWidget {
  const MarketplaceContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1000;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(width: 280, child: FiltersPanel()),
                SizedBox(width: 32),
                Expanded(child: ResultsColumn()),
              ],
            )
          : Column(
              children: const [
                FiltersPanel(),
                SizedBox(height: 24),
                ResultsColumn(),
              ],
            ),
    );
  }
}

class ResultsColumn extends StatefulWidget {
  const ResultsColumn({super.key});

  @override
  State<ResultsColumn> createState() => _ResultsColumnState();

  static Widget _pageButton(
    String text, {
    bool active = false,
    IconData? icon,
  }) {
    return Container(
      width: 42,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: icon != null
            ? Icon(icon)
            : Text(
                text,
                style: TextStyle(
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                ),
              ),
      ),
    );
  }
}

class _ResultsColumnState extends State<ResultsColumn> {
  String selectedSort = "relevance";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                      text: "128",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF001E40),
                      ),
                    ),
                    TextSpan(text: " services matching your criteria"),
                  ],
                ),
              ),
            ),

            Column(
              children: [
                Text("SORT BY:", style: TextStyle(fontWeight: FontWeight.bold)),

                DropdownButton<String>(
                  value: selectedSort,
                  onChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('This feature is not implemented yet'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    setState(() {
                      selectedSort = value!;
                    });

                    // Handle sorting logic here
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "relevance",
                      child: Text("Relevance"),
                    ),
                    DropdownMenuItem(
                      value: "price_low_high",
                      child: Text("Price: Low to High"),
                    ),
                    DropdownMenuItem(
                      value: "price_high_low",
                      child: Text("Price: High to Low"),
                    ),
                    DropdownMenuItem(value: "newest", child: Text("Newest")),
                  ],
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        const ServiceCard(
          title: "The Grand Azure Residenza",
          location: "Amalfi Coast, Italy",
          commission: "12%",
          description:
              "A sanctuary of refined luxury perched on the cliffs of Amalfi. Featuring private infinity pools and dedicated butler service.",
          image: "https://images.unsplash.com/photo-1578683010236-d716f9a3f461",
          tags: ["Infinity Pool", "Michelin Dining"],
        ),

        const SizedBox(height: 20),

        const ServiceCard(
          title: "Stellar Wing Charters",
          location: "Global Connectivity",
          commission: "8%",
          description:
              "Ultra-long-range private aviation services for executive groups.",
          image: "https://images.unsplash.com/photo-1436491865332-7a61a109cc05",
          tags: ["Pet Friendly", "Fast Track"],
        ),

        const SizedBox(height: 32),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResultsColumn._pageButton("1", active: true),
            ResultsColumn._pageButton("2"),
            ResultsColumn._pageButton("3"),
            ResultsColumn._pageButton("", icon: Icons.chevron_right),
          ],
        ),
      ],
    );
  }
}
