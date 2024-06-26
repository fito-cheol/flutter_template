import 'dart:async';
import 'dart:math';

import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_config/flutter_config.dart';

final apiKey = FlutterConfig.get('GOOGLE_MAPS_API_KEY');

class GooglePlaceSearch extends StatefulWidget {
  const GooglePlaceSearch({super.key});

  @override
  _GooglePlaceSearchState createState() => _GooglePlaceSearchState();
}

final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _GooglePlaceSearchState extends State<GooglePlaceSearch> {
  Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildDropdownMenu(),
        ElevatedButton(
          onPressed: _handlePressButton,
          child: const Text("Search places"),
        ),
        ElevatedButton(
          child: const Text("Custom"),
          onPressed: () {
            Navigator.of(context).pushNamed("/search");
          },
        ),
      ],
    ));
  }

  Widget _buildDropdownMenu() => DropdownButton(
        value: _mode,
        items: const <DropdownMenuItem<Mode>>[
          DropdownMenuItem<Mode>(
            value: Mode.overlay,
            child: Text("Overlay"),
          ),
          DropdownMenuItem<Mode>(
            value: Mode.fullscreen,
            child: Text("Fullscreen"),
          ),
        ],
        onChanged: (m) {
          setState(() {
            _mode = m!;
          });
        },
      );

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      onError: onError,
      mode: _mode,
      language: "kr",
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "kr")],
    );

    displayPrediction(p, context);
  }
}

Future<Null> displayPrediction(Prediction? p, BuildContext context) async {
  if (p == null) return;

  // get detail (lat/lng)
  GoogleMapsPlaces places = GoogleMapsPlaces(
    apiKey: apiKey,
    apiHeaders: await const GoogleApiHeaders().getHeaders(),
  );
  PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
  final lat = detail.result.geometry!.location.lat;
  final lng = detail.result.geometry!.location.lng;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("${p.description} - $lat/$lng")),
  );
}

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold({super.key})
      : super(
          apiKey: apiKey,
          sessionToken: Uuid().generateV4(),
          language: "en",
          components: [Component(Component.country, "uk")],
        );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, context);
      },
      logo: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [FlutterLogo()],
      ),
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse? response) {
    super.onResponse(response);
    if (response == null) return;
    if (response.predictions.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Got answer")),
      );
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
