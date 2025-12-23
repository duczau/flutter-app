// Example Screen1
import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> with RestorationMixin {
  @override
  String? get restorationId => 'screen1_state'; // Unique restoration ID

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Restore any restorable properties here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen 1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.restorablePush(
              context,
              MaterialPageRoute(builder: (context) => const Screen2())
                  as RestorableRouteBuilder<Object?>,
            );
          },
          child: const Text('Go to Screen 2'),
        ),
      ),
    );
  }
}

// Example Screen2 (similarly, create Screen3)
class Screen2 extends StatefulWidget {
  const Screen2({super.key, this.args});
  final Object? args;

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> with RestorationMixin {
  @override
  String? get restorationId => 'screen2_state';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen 2')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.restorablePush(
              context,
              MaterialPageRoute(builder: (context) => const Screen3())
                  as RestorableRouteBuilder<Object?>,
            );
          },
          child: const Text('Go to Screen 3'),
        ),
      ),
    );
  }
}

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> with RestorationMixin {
  @override
  String? get restorationId => 'screen3_state';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen 3')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: const Text('Go back to Screen 1'),
        ),
      ),
    );
  }
}
