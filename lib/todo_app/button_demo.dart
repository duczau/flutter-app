import 'package:flutter/material.dart';

class ButtonDemo extends StatefulWidget {
  const ButtonDemo({super.key});

  @override
  State<ButtonDemo> createState() {
    return _ButtonDemoState();
  }
}

class _ButtonDemoState extends State<ButtonDemo> {
  var _isUnderstood = false;
  @override
  Widget build(BuildContext context) {
    print('ButtonDemo BUILD called');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.red.shade50,
              ),
              onPressed: () {
                setState(() {
                  _isUnderstood = false;
                });
              },
              child: const Text('No'),
            ),
            const SizedBox(width: 24),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
                backgroundColor: Colors.green.shade50,
              ),
              onPressed: () {
                setState(() {
                  _isUnderstood = true;
                });
              },
              child: const Text('Yes'),
            ),
          ],
        ),
        if (_isUnderstood) const Text('Awesome!'),
      ],
    );
  }
}
