import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String locationName;

  MapView({required this.latitude, required this.longitude, required this.locationName});

  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<MapView> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _openGoogleMaps() async {
    final String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=${widget.latitude},${widget.longitude}';
    final Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng _center = LatLng(widget.latitude, widget.longitude);
    String location = widget.locationName;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location for exam'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Use any icon you prefer
          onPressed: () {
            // Navigate back to the previous page
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(location),
                  position: _center,
                ), // Marker
              }, // markers
            ),
          ),
          Center(
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _openGoogleMaps,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text(
                  'Open in Google Maps',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

          ),
        ],
      ),
    );



  }
}