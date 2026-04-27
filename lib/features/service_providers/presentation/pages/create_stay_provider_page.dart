import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/providers.dart';
import '../widgets/map_location_picker.dart';

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
  late TextEditingController _locationController;

  double? _selectedLatitude;
  double? _selectedLongitude;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _propertyTypeController = TextEditingController();
    _roomCountController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _propertyTypeController.dispose();
    _roomCountController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _createProvider() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLatitude == null || _selectedLongitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(serviceProviderRepositoryProvider);

      await repository.createStayProvider(
        providerName: _nameController.text,
        propertyType: _propertyTypeController.text,
        roomCount: int.tryParse(_roomCountController.text),
        latitude: _selectedLatitude!,
        longitude: _selectedLongitude!,
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
              // Location Selection Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location (Required)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_selectedLatitude != null && _selectedLongitude != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected: Lat ${_selectedLatitude!.toStringAsFixed(6)}, Lon ${_selectedLongitude!.toStringAsFixed(6)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (_locationController.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Details: ${_locationController.text}',
                                  style: const TextStyle(fontSize: 11),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _openMapPicker,
                      icon: const Icon(Icons.location_on),
                      label: _selectedLatitude == null
                          ? const Text('Select Location on Map')
                          : const Text('Change Location'),
                    ),
                  ],
                ),
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

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<LocationPickerModel>(
      context,
      MaterialPageRoute(
        builder: (context) => MapLocationPicker(
          onLocationSelected: (location) {},
          initialLatitude: _selectedLatitude ?? 11.610278,
          initialLongitude: _selectedLongitude ?? 76.08281,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLatitude = result.latitude;
        _selectedLongitude = result.longitude;
        _locationController.text =
            result.address ??
            'Location: ${result.latitude}, ${result.longitude}';
      });
    }
  }
}
