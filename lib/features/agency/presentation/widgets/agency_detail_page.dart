import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/providers.dart';
import '../../domain/usecases/remove_agency_staff_use_case.dart';
import '../notifiers/agency_detail_notifier.dart';
import '../notifiers/agency_staff_list_notifier.dart';

/// Page for displaying agency details with staff management.
///
/// Shows agency information and allows adding/managing staff members.
class AgencyDetailPage extends ConsumerStatefulWidget {
  final String agencyId;

  const AgencyDetailPage({super.key, required this.agencyId});

  @override
  ConsumerState<AgencyDetailPage> createState() => _AgencyDetailPageState();
}

class _AgencyDetailPageState extends ConsumerState<AgencyDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(agencyDetailProvider(widget.agencyId).notifier).loadAgency();
      ref.read(agencyStaffListProvider(widget.agencyId).notifier).loadStaffs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(agencyDetailProvider(widget.agencyId));
    final staffState = ref.watch(agencyStaffListProvider(widget.agencyId));

    return Scaffold(
      appBar: AppBar(title: const Text('Agency Details')),
      body: Builder(
        builder: (context) {
          if (detailState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (detailState.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${detailState.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(agencyDetailProvider(widget.agencyId).notifier)
                          .loadAgency();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (detailState.agency == null) {
            return const Center(child: Text('Agency not found'));
          }

          final agency = detailState.agency!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Agency Header
                Text(
                  agency.agencyName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'ID: ${agency.id}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),

                // Agency Information Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow('Name', agency.agencyName),
                        _InfoRow('Email', agency.contactEmail),
                        _InfoRow(
                          'Created',
                          agency.createdAt?.toString() ?? 'N/A',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Staff Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Staff Members',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        context
                            .push('/agencies/${widget.agencyId}/add-staff')
                            .then((_) {
                              // Reload staff list after returning from add staff page
                              ref
                                  .read(
                                    agencyStaffListProvider(
                                      widget.agencyId,
                                    ).notifier,
                                  )
                                  .loadStaffs();
                            });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Staff'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Staff List
                if (staffState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (staffState.error != null)
                  Center(
                    child: Text('Error loading staff: ${staffState.error}'),
                  )
                else if (staffState.staffs.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        'No staff members yet',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: staffState.staffs.length,
                    itemBuilder: (context, index) {
                      final staff = staffState.staffs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              staff.fullName?.substring(0, 1).toUpperCase() ??
                                  staff.userId.substring(0, 1).toUpperCase(),
                            ),
                          ),
                          title: Text(staff.fullName ?? staff.userId),
                          subtitle: Text(staff.role.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red,
                            onPressed: () {
                              // TODO: Update remove staff functionality to use notifier instead of direct use case call
                              final repository = ref.watch(
                                agencyRepositoryProvider,
                              );
                              RemoveAgencyStaffUseCase
                              removeAgencyStaffUseCase =
                                  RemoveAgencyStaffUseCase(repository);
                              removeAgencyStaffUseCase(
                                agencyId: widget.agencyId,
                                staffId: staff.id,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Staff removed successfully'),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Helper widget for displaying key-value pairs
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Flexible(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
