import 'package:first_app/basic_app/gradient_container.dart';
import 'package:first_app/basic_app/styled/styled_text.dart';
import 'package:first_app/quiz_app/quiz_app.dart';
import 'package:first_app/quiz_app/util/app_metrics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

void main() {
  runApp(
    // GradientApp(),
    // QuizApp()
    MainApp(),
  );
}

final Map<String, WidgetBuilder> listWitget = {
  'Quiz': (context) => QuizApp(),
  'Gradient': (context) => GradientApp(),
  'Counter': (context) => StyledText('Counter'),
  'Stateful Widget': (context) => StyledText('Stateful Widget'),
  'Stateless Widget': (context) => StyledText('Stateless Widget'),
};

// final Map<String, Widget> listWitget = {
//   'Quiz': const QuizApp(),
//   'Gradient': GradientApp(),
//   'Counter': const StyledText('Counter'),
//   'Stateful Widget': const StyledText('Stateful Widget'),
//   'Stateless Widget': const StyledText('Stateless Widget'),
// };

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      title: 'Main App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RootScaffold(MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class RootScaffold extends StatelessWidget {
  final Widget child;
  const RootScaffold(this.child, {super.key});

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceTint,
      title: const Text('Main App Scaffold'),
    );

    // Set global metrics so các màn khác có thể dùng
    AppMetrics.instance.setHeights(
      appBar: appBar.preferredSize.height,
      statusBar: MediaQuery.of(context).padding.top,
    );
    return Scaffold(
      appBar: appBar,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Main Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                  // context,
                  MaterialPageRoute(
                    builder: (context) => const RootScaffold(
                      MyHomePage(title: 'Flutter Demo Home Page'),
                    ),
                    settings: const RouteSettings(name: '/main'),
                  ),
                  (route) => false,
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Back'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.maybePop(context);
              },
            ),
          ],
        ),
      ), // Your custom drawer widget
      body: child, // This will be your current screen
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double get widthScreen => MediaQuery.sizeOf(context).width;
  double get heghtScreen => MediaQuery.sizeOf(context).height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Main App!',
                style: TextStyle(
                  fontSize: 34,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: const Color.fromARGB(235, 2, 11, 88),
                ),
              ),
              Divider(thickness: 10, color: Colors.black54, radius: BorderRadiusDirectional.circular(1)),
              SizedBox(height: widthScreen * 0.05),
              ...listWitget.entries.map((e) {
                String key = e.key;
                WidgetBuilder value = e.value;
                return OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RootScaffold(value(context)),
                        settings: RouteSettings(name: '/$key'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 233, 230, 230),
                    foregroundColor: const Color.fromARGB(255, 4, 46, 40),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 175, 57, 57),
                      width: 2,
                    ),
                  ),
                  icon: const Icon(Icons.park),
                  label: Text(key),
                );
              }),
              SizedBox(height: widthScreen * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
