import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabadmin/core/providers/providers.dart';

class CreateStayProviderPage extends ConsumerStatefulWidget {
  const CreateStayProviderPage({super.key});

  @override
  ConsumerState<CreateStayProviderPage> createState() =>
      _CreateStayProviderPageState();
}

class _CreateStayProviderPageState
    extends ConsumerState<CreateStayProviderPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _propertyTypeController;
  late TextEditingController _roomCountController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _propertyTypeController = TextEditingController();
    _roomCountController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _propertyTypeController.dispose();
    _roomCountController.dispose();
    super.dispose();
  }

  Future<void> _createProvider() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(serviceProviderRepositoryProvider);

      await repository.createStayProvider(
        providerName: _nameController.text,
        propertyType: _propertyTypeController.text,
        roomCount: int.tryParse(_roomCountController.text),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stay Provider created successfully!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Stay Provider')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Provider Name',
                  hintText: 'e.g., Paradise Hotel',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Provider name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _propertyTypeController,
                decoration: const InputDecoration(
                  labelText: 'Property Type',
                  hintText: 'e.g., Hotel, Hostel, Resort',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roomCountController,
                decoration: const InputDecoration(
                  labelText: 'Number of Rooms',
                  hintText: 'e.g., 20',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _createProvider,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Provider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
