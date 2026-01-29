import 'package:flutter/material.dart';
import 'package:location/location.dart';

class InputLocation extends StatefulWidget {
  const InputLocation({super.key});

  @override
  State<InputLocation> createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  Location? _pickedLocation;
  bool _isGettingLocation = false;

  // this method for mobile, not support web platform
  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });
    
    locationData = await location.getLocation();

    setState(() {
      _isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget locationContent = Text("No location chosen");

    // if (condition) {

    // }

    return Column(
      children: [
        Container(
          height: 200,
          width: 400,
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Center(child: locationContent),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              icon: Icon(Icons.my_location),
              onPressed: _getCurrentLocation,
              label: Text('Get current location'),
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              onPressed: () {},
              label: Text('Choose location'),
            ),
          ],
        ),
      ],
    );
  }
}
