import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rabadmin/core/providers/providers.dart';

class CreateStayUnitPage extends ConsumerStatefulWidget {
  final String providerId;

  const CreateStayUnitPage({required this.providerId, super.key});

  @override
  ConsumerState<CreateStayUnitPage> createState() => _CreateStayUnitPageState();
}

class _CreateStayUnitPageState extends ConsumerState<CreateStayUnitPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _roomRateController;
  late TextEditingController _perHeadRateController;
  late TextEditingController _maxOccupancyController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _roomRateController = TextEditingController();
    _perHeadRateController = TextEditingController();
    _maxOccupancyController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _roomRateController.dispose();
    _perHeadRateController.dispose();
    _maxOccupancyController.dispose();
    super.dispose();
  }

  Future<void> _createUnit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(serviceProviderRepositoryProvider);

      await repository.createStayUnit(
        widget.providerId,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        roomRate: int.tryParse(_roomRateController.text),
        perHeadRate: int.tryParse(_perHeadRateController.text),
        maxOccupancy: int.tryParse(_maxOccupancyController.text),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stay Unit created successfully!')),
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
      appBar: AppBar(title: const Text('Create Stay Unit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Unit Name',
                  hintText: 'e.g., Deluxe Room',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., Spacious room with AC and WiFi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roomRateController,
                decoration: const InputDecoration(
                  labelText: 'Room Rate (per night)',
                  hintText: '3000',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _perHeadRateController,
                decoration: const InputDecoration(
                  labelText: 'Per Head Rate',
                  hintText: '500',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxOccupancyController,
                decoration: const InputDecoration(
                  labelText: 'Max Occupancy',
                  hintText: '2',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _createUnit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Unit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
