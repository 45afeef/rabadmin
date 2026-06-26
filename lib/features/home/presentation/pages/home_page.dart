import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../auth/presentation/notifier/auth_notifier.dart';
import '../../../booking/presentation/notifiers/booking_notifier.dart';
import '../../../booking/presentation/widgets/booking_create_widget.dart';
import '../../../service_query/presentation/widgets/query_cab_widget.dart';
import '../../../service_query/presentation/widgets/query_driver_widget.dart';
import '../../../service_query/presentation/widgets/query_stay_widget.dart';
import 'second_home_page.dart' as second_home_page show HomePage;

// Color constants for each section
const List<Color> _appBarColors = [
  Color(0xFF4FACFE), // Stay - Blue
  Color(0xFFFF9966), // Cab - Orange
  Color(0xFF43E97B), // Driver - Green
  Color(0xFF8E2DE2), // Booking - Purple
];

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    StaySection(),
    CabSection(),
    DriverSection(),
    BookingSection(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _appBarColors[_currentIndex],
                _appBarColors[_currentIndex].withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Service Hub',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.business, color: Colors.white),
                onPressed: () => context.push(AppRoutes.agencies),
              ),
              IconButton(
                icon: const Icon(Icons.people, color: Colors.white),
                onPressed: () => context.push(AppRoutes.serviceProviders),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Stay',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_taxi),
            label: 'Cab',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Driver',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Book',
            backgroundColor: Colors.black,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigate to new home page using material page router push
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => second_home_page.HomePage(),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.home, color: Colors.black),
      ),
    );
  }
}

class StaySection extends ConsumerWidget {
  const StaySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      key: const ValueKey('stay'),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView(
        children: [
          SectionHeader(
            title: 'Find Your Stay',
            subtitle: 'Search by location, price, amenities & more',
          ),
          SizedBox(height: 16),
          StayQueryWidget(
            onStaySelected: (stay) {
              ref.read(bookingNotifierProvider.notifier).addStay(stay: stay);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected Stay: ${stay.name}')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CabSection extends ConsumerWidget {
  const CabSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      key: const ValueKey('cab'),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView(
        children: [
          SectionHeader(
            title: 'Book a Cab',
            subtitle: 'Quick rides with flexible options',
          ),
          SizedBox(height: 16),
          CabQueryWidget(
            onCabSelected: (cab) {
              ref.read(bookingNotifierProvider.notifier).addCab(cab: cab);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected Cab: ${cab.name}')),
              );
            },
            // Add onCabSelected callback if needed
          ),
        ],
      ),
    );
  }
}

class DriverSection extends ConsumerWidget {
  const DriverSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      key: const ValueKey('driver'),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView(
        children: [
          SectionHeader(
            title: 'Hire a Driver',
            subtitle: 'Professional drivers at your service',
          ),
          SizedBox(height: 16),
          DriverQueryWidget(
            onDriverSelected: (driver) {
              throw UnimplementedError("Driver selection not implemented yet");
            },
          ),
        ],
      ),
    );
  }
}

class BookingSection extends ConsumerWidget {
  const BookingSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      key: const ValueKey('booking'),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView(
        children: [
          SectionHeader(
            title: 'Your Bookings',
            subtitle: 'Manage your stay, cab & driver bookings',
          ),
          SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              ref.read(bookingNotifierProvider.notifier).clearDraft();
            },
            child: const Text('Clear Current Booking Draft'),
          ),

          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.push(AppRoutes.bookingList);
            },
            child: const Text('View All Bookings'),
          ),

          SizedBox(height: 16),
          BookingFormWidget(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            showSubmitButton: true,
            onSubmit: () {
              ref.read(bookingNotifierProvider.notifier).submitBooking();
            },
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
