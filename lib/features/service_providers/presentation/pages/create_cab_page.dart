import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/providers.dart';

class CreateCabPage extends ConsumerStatefulWidget {
  final String providerId;

  const CreateCabPage({required this.providerId, super.key});

  @override
  ConsumerState<CreateCabPage> createState() => _CreateCabPageState();
}

class _CreateCabPageState extends ConsumerState<CreateCabPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _vehicleTypeController;
  late TextEditingController _vehicleNumberController;
  late TextEditingController _minimumRateController;
  late TextEditingController _kmController;
  late TextEditingController _perKmRateController;
  late TextEditingController _capacityController;
  late TextEditingController _modelController;
  late TextEditingController _colorController;
  bool _isLoading = false;

  final List<String> _vehicleTypes = ['SEDAN', 'SUV', 'HATCHBACK', 'VAN'];
  late String _selectedVehicleType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _vehicleTypeController = TextEditingController();
    _vehicleNumberController = TextEditingController();
    _minimumRateController = TextEditingController();
    _kmController = TextEditingController();
    _perKmRateController = TextEditingController();
    _capacityController = TextEditingController();
    _modelController = TextEditingController();
    _colorController = TextEditingController();
    _selectedVehicleType = _vehicleTypes[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _vehicleTypeController.dispose();
    _vehicleNumberController.dispose();
    _minimumRateController.dispose();
    _kmController.dispose();
    _perKmRateController.dispose();
    _capacityController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _createCab() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(serviceProviderRepositoryProvider);

      await repository.createCab(
        widget.providerId,
        vehicleType: _selectedVehicleType,
        vehicleNumber: _vehicleNumberController.text,
        minimumRate: double.parse(_minimumRateController.text),
        kmForMinimumRate: double.parse(_kmController.text),
        perKmRate: double.parse(_perKmRateController.text),
        capacity: int.parse(_capacityController.text),
        name: _nameController.text,
        companyModel: _modelController.text,
        color: _colorController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cab created successfully!')),
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
      appBar: AppBar(title: const Text('Create Cab')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cab Name',
                  hintText: 'e.g., Hyundai i20',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedVehicleType,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Type',
                  border: OutlineInputBorder(),
                ),
                items: _vehicleTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedVehicleType = value ?? 'SEDAN'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _vehicleNumberController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  hintText: 'e.g., DL01AB1234',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _minimumRateController,
                decoration: const InputDecoration(
                  labelText: 'Minimum Rate',
                  hintText: '100',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kmController,
                decoration: const InputDecoration(
                  labelText: 'KM for Minimum Rate',
                  hintText: '5',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _perKmRateController,
                decoration: const InputDecoration(
                  labelText: 'Per KM Rate',
                  hintText: '20',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(
                  labelText: 'Capacity',
                  hintText: '4',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Company Model',
                  hintText: 'i20',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  hintText: 'White',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _createCab,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Cab'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
