import 'package:first_app/main.dart';
import 'package:first_app/quiz_app/quiz.dart';
import 'package:flutter/material.dart';

class AppBackgroundQuiz extends StatelessWidget {
  final List<Widget> children;

  const AppBackgroundQuiz({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/quiz/quiz-logo.png"),
          fit: BoxFit.contain,
          opacity: 0.05,
        ),
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(230, 37, 3, 43),
            const Color.fromARGB(255, 24, 30, 116),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flexible(
            //   child: Opacity(
            //     opacity: 0.5,
            //     child: Image.asset(
            //       "assets/quiz/quiz-logo.png",
            //       fit: BoxFit.contain,
            //     ),
            //   ),
            // ),
            ...this.children,
          ],
        ),
      ),
    );
  }
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
    //  MaterialApp(
    //   title: 'Quiz App',
    //   theme: ThemeData(primarySwatch: Colors.blue),
    //   home: MyHomePage(title: 'Flutter Demo Home Page'),
    // );
    MyHomePage(title: 'Flutter Demo Home Page');
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
    return AppBackgroundQuiz(
      children: <Widget>[
        SizedBox(height: heghtScreen * 0.05),
        Text(
          'Welcome to the Quiz App!',
          style: TextStyle(
            fontSize: 34,
            fontStyle: FontStyle.italic,
            color: const Color.fromARGB(235, 193, 190, 194),
          ),
        ),
        SizedBox(height: heghtScreen * 0.2),
        SizedBox(
          width: 200.0, // Set desired width
          height: 50.0, // Set desired height
          child: OutlinedButton.icon(
            autofocus: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RootScaffold(Quiz())),
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
            label: const Text('Start Quiz !!!'),
          ),
        ),
        SizedBox(height: heghtScreen * 0.2),
      ],
      // ),
      //   ),
      // ),
    );
    // drawer: Drawer(
    //   child: ListView(
    //     padding: EdgeInsets.zero,
    //     children: <Widget>[
    //       const DrawerHeader(
    //         decoration: BoxDecoration(color: Colors.blue),
    //         child: Text(
    //           'Main Menu',
    //           style: TextStyle(color: Colors.white, fontSize: 24),
    //         ),
    //       ),
    //       ListTile(
    //         leading: const Icon(Icons.home),
    //         title: const Text('Home'),
    //         onTap: () {
    //           Navigator.pop(context);
    //           Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(builder: (context) => const MainApp(), settings: const RouteSettings(name: '/main')),
    //           );
    //         },
    //       ),
    //       ListTile(
    //         leading: const Icon(Icons.settings),
    //         title: const Text('Settings'),
    //         onTap: () {
    //           Navigator.of(context, rootNavigator: true).maybePop();
    //         },
    //       ),
    //     ],
    //   ),
    // ),
  }
}
