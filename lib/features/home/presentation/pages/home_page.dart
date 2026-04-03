import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../service_query/presentation/widgets/query_stay_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: SafeArea(
        child: ListView(
          children: [
            const Center(child: Text('Welcome to the Home Page!')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).logout();
              },
              child: const Text('Logout'),
            ),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.agencies),
              child: const Text('Agencies List'),
            ),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.serviceProviders),
              child: const Text('Service Providers'),
            ),
            Text('You can search and filter STAY here'),
            Text('You can search and filter CAB here'),
            Text('Location, rate, PAX, amenities'),
            StayQueryWidget(),
          ],
        ),
      ),
    );
  }
}
