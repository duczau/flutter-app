import 'package:first_app/todo_app/button_demo.dart';
import 'package:flutter/material.dart';

class UIUpdatesDemo extends StatefulWidget {
  const UIUpdatesDemo({super.key});

  @override
  StatefulElement createElement() {
    print('UIUpdatesDemo CREATEELEMENT called');
    return super.createElement();
  }

  @override
  State<UIUpdatesDemo> createState() {
    return _UIUpdatesDemo();
  }
}

class _UIUpdatesDemo extends State<UIUpdatesDemo> {
  var _isUnderstood = false;

  @override
  Widget build(BuildContext context) {
    print('UIUpdatesDemo BUILD called');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Every Flutter developer should have a basic understanding of Flutter\'s internals!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Do you understand how Flutter updates UIs?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ButtonDemo(),  // chia các widget con thành 1 widget riêng để tránh rebuild toàn bộ (với các complex widget)
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     TextButton(
            //       style: TextButton.styleFrom(
            //         foregroundColor: Colors.red,
            //         backgroundColor: Colors.red.shade50,
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           _isUnderstood = false;
            //         });
            //       },
            //       child: const Text('No'),
            //     ),
            //     const SizedBox(width: 24),
            //     TextButton(
            //       style: TextButton.styleFrom(
            //         foregroundColor: Colors.green,
            //         backgroundColor: Colors.green.shade50,
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           _isUnderstood = true;
            //         });
            //       },
            //       child: const Text('Yes'),
            //     ),
            //   ],
            // ),
            // if (_isUnderstood) const Text('Awesome!'),
          ],
        ),
      ),
    );
  }
}