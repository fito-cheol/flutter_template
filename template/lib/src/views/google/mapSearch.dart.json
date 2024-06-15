import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class MapSampleView extends StatefulWidget {
  const MapSampleView({super.key});
  static const routeName = '/google/map';
  @override
  State<MapSampleView> createState() => MapSampleState();
}

class MapSampleState extends State<MapSampleView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchPlaces,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _searchPlaces() async {
    final GoogleMapController controller = await _controller.future;
    final String query = _searchController.text;

    if (query.isNotEmpty) {
      final places = await PlacesAutocomplete.show(
        context: context,
        apiKey: 'YOUR_API_KEY',
        mode: Mode.overlay,
        types: [],
        strictbounds: false,
        components: [Component(Component.country, 'us')],
        hint: 'Search places',
      );

      if (places != null) {
        final pinkParseStr = places.structuredFormatting.mainText;
        final placeDetails = await PlacesDetails.getDetails(
          places.placeId,
          fields: Set.from(['geometry']),
        );

        final position = placeDetails.geometry.location;
        final request = PlacesSearchRequest(
          location: LatLng(position.lat, position.lng),
          radius: 500,
          type: PlaceType.restaurant,
          rankBy: RankBy.PROMINENCE,
        );

        final response = await GoogleMapsPlaces(
          apiKey: 'YOUR_API_KEY',
          apiHeaders: await GoogleApiHeaders().getHeaders(),
        ).searchNearby(request);

        setState(() {
          _markers = response.results
              .map(
                (place) => Marker(
                  markerId: MarkerId(place.placeId),
                  position: LatLng(
                    place.geometry.location.lat,
                    place.geometry.location.lng,
                  ),
                  infoWindow: InfoWindow(
                    title: place.name,
                    snippet: place.vicinity,
                  ),
                ),
              )
              .toSet();
        });

        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.lat, position.lng),
            14.0,
          ),
        );
      }
    }
  }
}
