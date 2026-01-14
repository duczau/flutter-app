import 'package:first_app/basic_app/gradient_container.dart';
import 'package:first_app/basic_app/styled/styled_text.dart';
import 'package:first_app/basic_app/test_animate.dart';
import 'package:first_app/expense_app/expenses_app.dart';
import 'package:first_app/meals_app/screens/categories.dart';
import 'package:first_app/meals_app/screens/tabs.dart';
import 'package:first_app/quiz_app/quiz_app.dart';
import 'package:first_app/quiz_app/util/app_metrics.dart';
import 'package:first_app/todo_app/todo_app.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

var kDarkColorTheme = const Color.fromARGB(255, 18, 18, 18);
var themeMode = ThemeMode.light;

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized(); 
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MainApp());
}

final Map<String, WidgetBuilder> listWitget = {
  'Quiz': (context) => QuizApp(),
  'Gradient': (context) => GradientApp(),
  'Expenses Tracker': (context) => Expenses(),
  'Todo App': (context) => TodoApp(),
  'Drag ball bouncing': (context) => TestAnimate(),
};

final Map<String, WidgetBuilder> listWitget2 = {
  'Meals App': (context) => TabScreen(),
};

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override 
  State<StatefulWidget> createState() {
    return _MainAppState();
  }
}

class _MainAppState extends State<MainApp> {
  void _toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: themeMode,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kDarkColorTheme,
      ),
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      title: 'Main App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 37, 106, 146),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 13, 134, 74),
        ),
        cardTheme: const CardThemeData(
          color: Color.fromARGB(206, 128, 179, 128),
          shadowColor: Color.fromARGB(255, 96, 71, 236),
          elevation: 10,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 194, 81, 81),
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(255, 1, 69, 172),
            fontWeight: FontWeight.w300,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Roboto',
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 0, 0, 0),
            fontFamily: 'Roboto',
            fontStyle: FontStyle.italic,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 0, 0, 0),
            fontFamily: 'Roboto',
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 96, 59, 181),
          secondary: const Color.fromARGB(255, 181, 59, 96),
        ),
      ),
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
        child: Column(
          children: <Widget>[
            // ✅ Header cố định (không scroll)
            // const DrawerHeader(
            //   padding: EdgeInsets.zero,
            //   decoration: BoxDecoration(color: Colors.blue, ),
            //   child: Text(
            //     'Main Menu',
            //     style: TextStyle(color: Colors.white, fontSize: 24),
            //   ),
            // ),
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.blue,
              // padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const Text(
                'Main Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            // ✅ Nội dung scroll
            Expanded(
              child: ListView(
                children: <Widget>[
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
                        // (route) => false, // xoá tất cả
                        // (route) => route.isFirst, // Giữ route đầu tiên
                        // (route) => route.settings.name == '/login', // Giữ route cụ thể
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
            ),
            const Divider(indent: 16.0, endIndent: 16.0),
            ListTile(
              leading: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              title: const Text(
                'Dark Mode',
                strutStyle: StrutStyle(height: 1.5),
              ),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  (context as Element)
                      .findAncestorStateOfType<_MainAppState>()
                      ?._toggleTheme();
                  // Navigator.pop(context); // Đóng drawer
                },
              ),
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
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.surfaceTint,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Main App!',
              style: TextStyle(
                fontSize: 34,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.acme().fontFamily,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            Divider(
              thickness: 5,
              color: Colors.lime,
              radius: BorderRadiusDirectional.circular(1),
            ),
            SizedBox(height: widthScreen * 0.05),
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: listWitget.values.length,
                itemBuilder: (context, index) {
                  String key = listWitget.entries.elementAt(index).key;
                  WidgetBuilder value = listWitget.entries.elementAt(index).value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton.icon(
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        icon: const Icon(Icons.park),
                        label: Text(key),
                      ),
                    ],
                  );
                },
              ),
            ),
            Divider(
              thickness: 5,
              color: const Color.fromARGB(255, 42, 78, 179),
              radius: BorderRadiusDirectional.circular(1),
            ),
            SizedBox(height: widthScreen * 0.05),
            Flexible(child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: listWitget2.values.length,
                itemBuilder: (context, index) {
                  String key = listWitget2.entries.elementAt(index).key;
                  WidgetBuilder value = listWitget2.entries.elementAt(index).value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => value(context),
                              settings: RouteSettings(name: '/$key'),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 233, 230, 230),
                          foregroundColor: const Color.fromARGB(255, 4, 46, 40),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 166, 182, 97),
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        icon: const Icon(Icons.ring_volume_rounded),
                        label: Text(key),
                      ),
                    ],
                  );
                },
              ),
              ),
            SizedBox(height: widthScreen * 0.05),
          ],
        ),
      ),
    );
  }
}
