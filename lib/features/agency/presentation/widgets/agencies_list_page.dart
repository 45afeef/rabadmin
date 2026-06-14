import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../notifiers/agencies_list_notifier.dart';
import 'agency_form.dart';
import '../notifiers/agency_create_notifier.dart';

/// Page for displaying a list of all agencies.
///
/// Shows all agencies and allows viewing details, creating new agencies,
/// and managing staff through a long-press context menu.
class AgenciesListPage extends ConsumerStatefulWidget {
  const AgenciesListPage({super.key});

  @override
  ConsumerState<AgenciesListPage> createState() => _AgenciesListPageState();
}

class _AgenciesListPageState extends ConsumerState<AgenciesListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(agenciesListProvider.notifier).loadAgencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(agenciesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Agencies')),
      body: Builder(
        builder: (context) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
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

          if (state.agencies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.business_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text('No agencies found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(agenciesListProvider.notifier).loadAgencies();
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(agenciesListProvider.notifier).loadAgencies(),
            child: ListView.builder(
              itemCount: state.agencies.length,
              itemBuilder: (context, index) {
                final agency = state.agencies[index];
                return _AgencyListItem(
                  agency: agency,
                  onTap: () {
                    context.push('/agencies/${agency.id}');
                  },
                  onAddStaff: () {
                    context.push('/agencies/${agency.id}/add-staff').then((_) {
                      // Optionally refresh the list after adding staff
                      ref.read(agenciesListProvider.notifier).loadAgencies();
                    });
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateAgencyBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateAgencyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: AgencyForm(
            onSubmit: (agency) async {
              await ref
                  .read(agencyCreateProvider.notifier)
                  .createAgency(agency);

              if (context.mounted) Navigator.pop(context);
              // Check if creation was successful
              final createState = ref.read(agencyCreateProvider);
              if (createState.error != null) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 5),
                      content: Text('Error: ${createState.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                return;
              }

              // Success case
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Agency created successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }

              // Refresh the list
              Future.delayed(const Duration(milliseconds: 500), () {
                ref.read(agenciesListProvider.notifier).loadAgencies();
              });
            },
          ),
        );
      },
    );
  }
}

/// Individual agency list item with long-press context menu.
class _AgencyListItem extends StatelessWidget {
  final dynamic agency;
  final VoidCallback onTap;
  final VoidCallback onAddStaff;

  const _AgencyListItem({
    required this.agency,
    required this.onTap,
    required this.onAddStaff,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: ListTile(
        leading: CircleAvatar(child: Text(agency.agencyName[0].toUpperCase())),
        title: Text(agency.agencyName ?? 'Unknown'),
        subtitle: Text(agency.contactEmail ?? 'N/A'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              agency.agencyName ?? 'Agency',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add Staff Member'),
              onTap: () {
                Navigator.pop(context);
                onAddStaff();
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Staff'),
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Close'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
