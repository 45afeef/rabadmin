import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/providers.dart';

class AddAmenityPage extends ConsumerStatefulWidget {
  final String providerId;
  final String unitId;

  const AddAmenityPage({
    required this.providerId,
    required this.unitId,
    super.key,
  });

  @override
  ConsumerState<AddAmenityPage> createState() => _AddAmenityPageState();
}

class _AddAmenityPageState extends ConsumerState<AddAmenityPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amenityController;
  bool _isLoading = false;

  final List<String> _amenityScopes = ['ROOM', 'COMMON', 'PRIVATE'];
  late String _selectedScope;

  @override
  void initState() {
    super.initState();
    _amenityController = TextEditingController();
    _selectedScope = _amenityScopes[0];
  }

  @override
  void dispose() {
    _amenityController.dispose();
    super.dispose();
  }

  Future<void> _addAmenity() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(serviceProviderRepositoryProvider);

      await repository.addAmenity(
        widget.providerId,
        widget.unitId,
        amenity: _amenityController.text,
        amenityScope: _selectedScope,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Amenity added successfully!')),
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
      appBar: AppBar(title: const Text('Add Amenity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amenityController,
                decoration: const InputDecoration(
                  labelText: 'Amenity Name',
                  hintText: 'e.g., WiFi, AC, TV',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Amenity is required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedScope,
                decoration: const InputDecoration(
                  labelText: 'Amenity Scope',
                  border: OutlineInputBorder(),
                ),
                items: _amenityScopes
                    .map(
                      (scope) =>
                          DropdownMenuItem(value: scope, child: Text(scope)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedScope = value ?? 'ROOM'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _addAmenity,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add Amenity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
