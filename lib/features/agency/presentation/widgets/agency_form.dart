import 'package:flutter/material.dart';

import '../../domain/entities/agency.dart';

class AgencyForm extends StatefulWidget {
  final void Function(Agency agency) onSubmit;
  final Agency? initialAgency;

  const AgencyForm({super.key, required this.onSubmit, this.initialAgency});

  @override
  State<AgencyForm> createState() => _AgencyFormState();
}

class _AgencyFormState extends State<AgencyForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _agencyNameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _agencyNameController = TextEditingController(
      text: widget.initialAgency?.agencyName ?? '',
    );
    _emailController = TextEditingController(
      text: widget.initialAgency?.contactEmail ?? '',
    );
  }

  @override
  void dispose() {
    _agencyNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final agency = Agency(
      id: widget.initialAgency?.id ?? UniqueKey().toString(),
      agencyName: _agencyNameController.text.trim(),
      contactEmail: _emailController.text.trim(),
    );

    widget.onSubmit(agency);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _agencyNameController,
            decoration: const InputDecoration(labelText: 'Agency Name'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Agency name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Contact Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              if (!value.contains('@')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _submit,
            child: Text(
              widget.initialAgency == null ? 'Create Agency' : 'Update Agency',
            ),
          ),
        ],
      ),
    );
  }
}
