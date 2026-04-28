import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerModel {
  final double latitude;
  final double longitude;
  final String? address;

  LocationPickerModel({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  @override
  String toString() =>
      'LocationPickerModel(lat: $latitude, lon: $longitude, address: $address)';
}

class MapLocationPicker extends StatefulWidget {
  final void Function(LocationPickerModel location) onLocationSelected;
  final double initialLatitude;
  final double initialLongitude;

  const MapLocationPicker({
    super.key,
    required this.onLocationSelected,
    // Default to Kerala center if not provided
    this.initialLatitude = 10.8505,
    this.initialLongitude = 76.2711,
  });

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  late MapController _mapController;
  late LatLng _selectedLocation;
  String? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedLocation = LatLng(widget.initialLatitude, widget.initialLongitude);
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _selectedAddress = null; // Reset address when tapping
    });

    // Notify parent with selected location
    widget.onLocationSelected(
      LocationPickerModel(
        latitude: location.latitude,
        longitude: location.longitude,
        address: _selectedAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(
                context,
                LocationPickerModel(
                  latitude: _selectedLocation.latitude,
                  longitude: _selectedLocation.longitude,
                  address: _selectedAddress,
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 13.0,
              onTap: (tapPosition, point) => _onMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.redandblack.rabadmin',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Location info card
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Latitude: ${_selectedLocation.latitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    Text(
                      'Longitude: ${_selectedLocation.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    if (_selectedAddress != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Address: $_selectedAddress',
                          style: const TextStyle(fontSize: 11),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
