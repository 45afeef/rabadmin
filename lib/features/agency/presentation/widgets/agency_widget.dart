import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/agencies_list_notifier.dart';
import "../notifiers/agency_create_notifier.dart";
import 'agency_form.dart';

// ============================================================================
// EXAMPLE 1: Display List of Agencies
// ============================================================================

/// Example widget that displays a list of all agencies.
///
/// This demonstrates:
/// - Using the agenciesListProvider to watch state changes
/// - Handling loading state
/// - Handling error state
/// - Displaying agency data in a ListView
class AgenciesListExample extends ConsumerStatefulWidget {
  const AgenciesListExample({super.key});

  @override
  ConsumerState<AgenciesListExample> createState() =>
      _AgenciesListExampleState();
}

class _AgenciesListExampleState extends ConsumerState<AgenciesListExample> {
  @override
  void initState() {
    super.initState();
    // Load agencies when widget is first built
    Future.microtask(() {
      ref.read(agenciesListProvider.notifier).loadAgencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the agencies list state
    final state = ref.watch(agenciesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Agencies')),
      body: Builder(
        builder: (context) {
          // Show loading indicator while fetching data
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message if something went wrong
          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  ElevatedButton(
                    onPressed: () {
                      // Clear error and retry
                      ref.read(agenciesListProvider.notifier)
                        ..clearError()
                        ..loadAgencies();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show empty state if no agencies
          if (state.agencies.isEmpty) {
            return const Center(child: Text('No agencies found'));
          }

          // Display list of agencies
          return ListView.builder(
            itemCount: state.agencies.length,
            itemBuilder: (context, index) {
              final agency = state.agencies[index];
              return ListTile(
                title: Text(agency.agencyName),
                subtitle: Text(agency.contactEmail),
                onTap: () {
                  // Navigate to agency detail page
                  // Navigator.push(context, MaterialPageRoute(...))
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final agencyCreationProvider = ref.read(
            agencyCreateProvider.notifier,
          );
          // Open up the bottom sheet to show agencies create form
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(16),
                child: AgencyForm(
                  onSubmit: (agency) {
                    agencyCreationProvider.createAgency(agency);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
