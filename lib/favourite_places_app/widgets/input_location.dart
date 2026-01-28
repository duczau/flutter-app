import 'package:flutter/material.dart';

class InputLocation extends StatefulWidget {
  const InputLocation({super.key});

  @override
  State<InputLocation> createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              icon: Icon(Icons.my_location),
              onPressed: () {},
              label: Text('Get current location'),
            ),
            TextButton.icon(
              icon: Icon(Icons.location_pin),
              onPressed: () {},
              label: Text('Choose location'),
            ),
          ],
        ),
      ],
    );
  }
}
