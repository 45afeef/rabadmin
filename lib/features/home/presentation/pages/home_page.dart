import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: SafeArea(
        child: Column(
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
              onPressed: () => context.push(AppRoutes.myAgenicies),
              child: const Text('Agencies List'),
            ),
          ],
        ),
      ),
    );
  }
}
