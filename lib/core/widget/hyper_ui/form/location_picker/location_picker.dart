import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reusekit/core.dart';
import 'package:latlong2/latlong.dart';

class QLocationPicker extends StatefulWidget {
  const QLocationPicker({
    required this.onChanged,
    super.key,
    this.label,
    this.hint,
    this.helper,
    this.latitude,
    this.longitude,
    this.validator,
    this.enableEdit = true,
  });

  final String? label;
  final String? hint;
  final String? helper;
  final double? latitude;
  final double? longitude;
  final String? Function(String?)? validator;
  final Function(double latitude, double longitude, String address) onChanged;
  final bool enableEdit;

  @override
  _QLocationPickerState createState() => _QLocationPickerState();
}

class _QLocationPickerState extends State<QLocationPicker> {
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    if (widget.latitude != null && widget.longitude != null) {
      _currentLocation = LatLng(
        widget.latitude!,
        widget.longitude!,
      );
    } else {
      _setCurrentLocationToUserLocation();
    }
  }

  Future<LatLng> _getUserCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    return LatLng(
      position.latitude,
      position.longitude,
    );
  }

  void _setCurrentLocationToUserLocation() async {
    final userLocation = await _getUserCurrentLocation();
    final address = await _getAddressFromCoordinates(userLocation);
    setState(() {
      _currentLocation = userLocation;
    });
    widget.onChanged(userLocation.latitude, userLocation.longitude, address);
  }

  Future<String> _getAddressFromCoordinates(LatLng location) async {
    // Replace with actual reverse geocoding implementation
    return "Placeholder Address for (${location.latitude}, ${location.longitude})";
  }

  void _onLocationSelected(LatLng newLocation) async {
    final address = await _getAddressFromCoordinates(newLocation);
    setState(() {
      _currentLocation = newLocation;
    });
    widget.onChanged(newLocation.latitude, newLocation.longitude, address);
  }

  void _openFullScreenPicker(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenLocationPicker(
          initialLocation: _currentLocation!,
          onLocationPicked: _onLocationSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return Center(
        child: Text("..."),
      );
    }

    final buttonText =
        (_currentLocation!.latitude != (widget.latitude ?? -6.1751) ||
                _currentLocation!.longitude != (widget.longitude ?? 106.8650))
            ? 'Change Location'
            : (widget.hint ?? 'Select Location');
    final buttonColor =
        (_currentLocation!.latitude != (widget.latitude ?? -6.1751) ||
                _currentLocation!.longitude != (widget.longitude ?? 106.8650))
            ? Colors.grey
            : Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        if (widget.helper != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.helper!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        const SizedBox(
          height: 8.0,
        ),
        SizedBox(
          //default button height
          height: 42,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () => _openFullScreenPicker(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
            ),
            child: Text(buttonText),
          ),
        ),
        //if location selected display text latitude, longitude?
        if (_currentLocation!.latitude != (widget.latitude ?? -6.1751) ||
            _currentLocation!.longitude != (widget.longitude ?? 106.8650))
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Clipboard.setData(
                ClipboardData(
                  text:
                      '${_currentLocation!.latitude}, ${_currentLocation!.longitude}',
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '${_currentLocation!.latitude}, ${_currentLocation!.longitude}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 8.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class FullScreenLocationPicker extends StatefulWidget {
  const FullScreenLocationPicker({
    required this.initialLocation,
    required this.onLocationPicked,
    super.key,
  });

  final LatLng initialLocation;
  final Function(LatLng location) onLocationPicked;

  @override
  _FullScreenLocationPickerState createState() =>
      _FullScreenLocationPickerState();
}

class _FullScreenLocationPickerState extends State<FullScreenLocationPicker> {
  late LatLng _currentLocation;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  Timer? _debounce;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _currentLocation = widget.initialLocation;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _onSearch(_searchController.text);
      }
    });
  }

  Future<void> _onSearch(String query) async {
    final url =
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5';
    final response = await Dio().get(url);

    if (response.statusCode == 200) {
      final List data = response.data;
      setState(() {
        _searchResults = data.map((location) {
          return {
            'displayName': location['display_name'],
            'lat': double.parse(location['lat']),
            'lon': double.parse(location['lon']),
          };
        }).toList();
      });
    } else {
      // Handle error
    }
  }

  Future<LatLng> _getUserCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    return LatLng(
      position.latitude,
      position.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          height: 42,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search location',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 15.0,
                onPositionChanged: (position, hasGesture) {
                  if (hasGesture) {
                    setState(() {
                      _currentLocation = position.center;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  // Removed subdomains to comply with OSM's tile server policy
                ),
              ],
            ),
            Center(
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
            Positioned(
              bottom: 80,
              right: 16,
              child: FloatingActionButton(
                onPressed: () async {
                  // Get the user's current location
                  // This requires the appropriate permissions and location services enabled
                  // Replace with actual implementation to get the user's current location
                  LatLng userLocation = await _getUserCurrentLocation();
                  setState(() {
                    _currentLocation = userLocation;
                  });
                  _mapController.move(userLocation, 15.0);
                },
                key: Key('location_picker_myLocation'),
                heroTag: 'location_picker_myLocation',
                child: Icon(Icons.my_location),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  widget.onLocationPicked(_currentLocation);
                  Navigator.of(context).pop();
                },
                key: Key('location_picker_confirm'),
                heroTag: 'location_picker_confirm',
                child: Icon(Icons.check),
              ),
            ),
            if (_searchResults.isNotEmpty)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return Container(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
                          title: Text(
                            result['displayName'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                          onTap: () {
                            final lat = result['lat'];
                            final lon = result['lon'];
                            setState(() {
                              _currentLocation = LatLng(lat, lon);
                              _searchResults.clear();
                              _searchController.clear();
                            });
                            _mapController.move(LatLng(lat, lon), 15.0);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
