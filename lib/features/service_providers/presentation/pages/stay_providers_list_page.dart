import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Displays all stay service providers and allows navigation to details or
/// creation of a new provider.
class StayProvidersListPage extends ConsumerWidget {
  const StayProvidersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stay Providers')),
      body: SizedBox(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/service-providers/stay/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
