import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/agency_staff.dart';
import '../controllers/add_staff_notifier.dart';

/// Page for adding staff to an agency.
///
/// This page allows users to either create a new user and add them as staff,
/// or assign an existing user as staff to the agency.
class AddStaffPage extends ConsumerStatefulWidget {
  final String agencyId;

  const AddStaffPage({super.key, required this.agencyId});

  @override
  ConsumerState<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends ConsumerState<AddStaffPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load available users when the page opens
    Future.microtask(() {
      ref.read(addStaffProvider(widget.agencyId).notifier).loadAvailableUsers();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addStaffProvider(widget.agencyId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Staff'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Create New User'),
            Tab(text: 'Assign Existing User'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CreateNewUserTab(agencyId: widget.agencyId),
          _AssignExistingUserTab(
            agencyId: widget.agencyId,
            availableUsers: state.availableUsers,
            isLoadingUsers: state.isLoadingUsers,
          ),
        ],
      ),
    );
  }
}

/// Tab for creating a new user and adding them as staff.
class _CreateNewUserTab extends ConsumerStatefulWidget {
  final String agencyId;

  const _CreateNewUserTab({required this.agencyId});

  @override
  ConsumerState<_CreateNewUserTab> createState() => _CreateNewUserTabState();
}

class _CreateNewUserTabState extends ConsumerState<_CreateNewUserTab> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();
    _selectedRole = StaffRole.AGENT.name;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addStaffProvider(widget.agencyId));

    ref.listen(addStaffProvider(widget.agencyId), (previous, next) {
      if (previous?.staff == null && next.staff != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Staff added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) context.pop();
        });
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Full name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Password is required';
                }
                if (value!.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Phone number is required';
                }
                // Basic phone number validation
                final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
                if (!phoneRegex.hasMatch(value!)) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Staff Role',
                border: OutlineInputBorder(),
              ),
              items: StaffRole.values.map((role) {
                return DropdownMenuItem(
                  value: role.name,
                  child: Text(role.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
            const SizedBox(height: 24),
            if (state.error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  state.error!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        final names = _fullNameController.text.split(' ');
                        final firstName = names.isNotEmpty ? names[0] : '';
                        final lastName = names.length > 1
                            ? names.sublist(1).join(' ')
                            : '';

                        ref
                            .read(addStaffProvider(widget.agencyId).notifier)
                            .createUserAndAddAsStaff(
                              firstName: firstName,
                              lastName: lastName,
                              email:
                                  '${firstName.toLowerCase()}.${lastName.toLowerCase()}@agency.local',
                              password: _passwordController.text,
                              phone: _phoneController.text,
                              role: _selectedRole!,
                            );
                      }
                    },
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create User & Add as Staff'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tab for assigning an existing user as staff.
class _AssignExistingUserTab extends ConsumerStatefulWidget {
  final String agencyId;
  final List<Map<String, dynamic>> availableUsers;
  final bool isLoadingUsers;

  const _AssignExistingUserTab({
    required this.agencyId,
    required this.availableUsers,
    required this.isLoadingUsers,
  });

  @override
  ConsumerState<_AssignExistingUserTab> createState() =>
      _AssignExistingUserTabState();
}

class _AssignExistingUserTabState
    extends ConsumerState<_AssignExistingUserTab> {
  String? _selectedUserId;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = StaffRole.AGENT.name;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addStaffProvider(widget.agencyId));

    ref.listen(addStaffProvider(widget.agencyId), (previous, next) {
      if (previous?.staff == null && next.staff != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Staff added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) context.pop();
        });
      }
    });

    if (widget.isLoadingUsers) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.availableUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No users available'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(addStaffProvider(widget.agencyId).notifier)
                    .loadAvailableUsers();
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedUserId,
            decoration: const InputDecoration(
              labelText: 'Select User',
              border: OutlineInputBorder(),
              hintText: 'Choose a user to add as staff',
            ),
            items: widget.availableUsers.map((user) {
              final userId = user['id'] as String? ?? '';
              final fullName = user['full_name'] as String? ?? 'Unknown';

              return DropdownMenuItem(value: userId, child: Text(fullName));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedUserId = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedRole,
            decoration: const InputDecoration(
              labelText: 'Staff Role',
              border: OutlineInputBorder(),
            ),
            items: StaffRole.values.map((role) {
              return DropdownMenuItem(value: role.name, child: Text(role.name));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRole = value;
              });
            },
          ),
          const SizedBox(height: 24),
          if (state.error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                state.error!,
                style: TextStyle(color: Colors.red.shade900),
              ),
            ),
            const SizedBox(height: 16),
          ],
          ElevatedButton(
            onPressed: state.isLoading || _selectedUserId == null
                ? null
                : () {
                    ref
                        .read(addStaffProvider(widget.agencyId).notifier)
                        .addUserAsStaff(
                          userId: _selectedUserId!,
                          role: _selectedRole!,
                        );
                  },
            child: state.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Add as Staff'),
          ),
        ],
      ),
    );
  }
}
