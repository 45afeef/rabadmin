import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';

/// Simple landing page for the service providers section. Allows users to
/// choose between cab or stay providers.
class ServiceProvidersHomePage extends StatelessWidget {
  const ServiceProvidersHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Providers')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.cabProviders),
              child: const Text('Cab Providers'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.stayProviders),
              child: const Text('Stay Providers'),
            ),
          ],
        ),
      ),
    );
  }
}
