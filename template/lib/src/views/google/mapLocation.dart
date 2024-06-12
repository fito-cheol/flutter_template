import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'dart:async';

class MapScreen extends StatefulWidget {
  static const routeName = '/google/map/location';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Location _location = Location();
  LocationData? _currentPosition;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await _location.getLocation();

    final GoogleMapController controller = await _controller.future;

    if (_currentPosition?.latitude == null) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: LatLng(37.5519, 126.9918),
            zoom: 15.0,
          ),
        ),
      );
    } else {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                _currentPosition!.latitude!, _currentPosition!.longitude!),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        // CameraPosition(
        //   target:
        //       LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
        //   zoom: 15.0,
        // ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
