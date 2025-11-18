import 'dart:math';

import 'package:first_app/basic_app/animate_physics_simulation.dart';
import 'package:first_app/basic_app/animate_physics_test.dart';
import 'package:first_app/basic_app/dice_roller.dart';
import 'package:first_app/basic_app/styled/styled_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Alignment? startAlignment;
Alignment? endAlignment;

int clickCounter = 0;

var waitText = 'Roll Dice!';

void handleButtonClick() {
  clickCounter++;
  print('Click detected. Current count: $clickCounter');

  // Schedule a check for one second later
  Future.delayed(const Duration(seconds: 1), () {
    print('Count after 1 second: $clickCounter');
    clickCounter = 0; // Reset for the next second
  });
}

Duration handleDuration() {
  return Duration(milliseconds: 1000);
}

class GradientApp extends StatelessWidget {
  final List<Color> colors = [];
  GradientApp({super.key}) {
    colors.addAll({
      const Color.fromARGB(255, 39, 176, 119).withBlue(1),
      const Color.fromARGB(177, 68, 69, 124),
      const Color.fromARGB(178, 187, 98, 157),
      const Color.fromARGB(206, 229, 231, 69),
    });
    if (kDebugMode) {
      print(super.key.toString());
    }
  }

  GradientApp.namedConstructor(List<Color> colors, {super.key}) {
    this.colors.addAll(colors);
    if (kDebugMode) {
      print('Named constructor called');
    }
  }

  @override
  StatelessElement createElement() {
    if (kDebugMode) {
      print(super.createElement());
      print(kDebugMode);
    }
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    startAlignment = Alignment.bottomLeft;
    endAlignment = Alignment.topRight;
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(
    //       seedColor: const Color.fromARGB(255, 168, 14, 168),
    //     ),
    //   ),
    //   home: MyHomePage(title: 'Flutter Demo Home Page', colors: colors),
    // );
    return MyHomePage(title: 'Flutter Demo Home Page', colors: colors);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.colors});

  final String title;
  final List<Color> colors;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _randomTop = 0.0;
  double _randomLeft = 0.0;
  double get widthScreen => MediaQuery.sizeOf(context).width;
  double get heghtScreen => MediaQuery.sizeOf(context).height;

  List<Image> diceImages = [
    Image.asset("assets/images/dice-1.png"),
    Image.asset("assets/images/dice-2.png"),
    Image.asset("assets/images/dice-3.png"),
    Image.asset("assets/images/dice-4.png"),
    Image.asset("assets/images/dice-5.png"),
    Image.asset("assets/images/dice-6.png"),
  ];

  Image dice = Image.asset("assets/images/dice-1.png");
  void rollDice(Image newDice) {
    setState(() {
      dice = newDice;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter = Random().nextInt(100);
    });

    // count clicks
    handleButtonClick();

    if (clickCounter > 2) {
      waitText = 'Too many clicks! Calm down!';
    } else {
      waitText = 'wait me!';
    }

    final random = Random();
    // Get screen dimensions after the widget has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      setState(() {
        _randomTop =
            random.nextDouble() *
            (screenHeight - 100); // Adjust 50 for text height
        _randomLeft =
            random.nextDouble() *
            (screenWidth - 150); // Adjust 100 for text width
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: BackButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  // Ở trang đầu, không thể pop — có thể xử lý khác
                  print('Already at first route');
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 233, 230, 230),
                foregroundColor: const Color.fromARGB(255, 4, 46, 40),
                side: const BorderSide(
                  color: Color.fromARGB(255, 175, 57, 57),
                  width: 2,
                ),
              ),
              color: Colors.white,
            ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: startAlignment == null
                ? Alignment.bottomLeft
                : startAlignment!,
            end: endAlignment == null ? Alignment.topRight : endAlignment!,
            colors: widget.colors,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              // mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                const Text('Count clicked:'),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text('left: $_randomLeft'),
                Text('top: $_randomTop'),
                Text('screen: $widthScreen x $heghtScreen'),
              ],
            ),
            DraggableCard(
              startTop: _randomTop,
              startLeft: _randomLeft,
              child: SizedBox(width: 100, height: 100, child: dice),
            ),
            // SpringBounceDemo(),
            AnimatedPositioned(
              duration: handleDuration(),
              curve: Curves.fastOutSlowIn,
              top: _randomTop + 100,
              left: _randomLeft + 5,
              onEnd: () {
                setState(() {
                  waitText = "Roll Dice!";
                });
              },
              child: Center(
                child: DiceRoller(
                  onDiceRolled: rollDice,
                  text: waitText,
                  diceImages: diceImages,
                ),
              ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        backgroundColor: Color.fromARGB(188, 161, 9, 6),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
