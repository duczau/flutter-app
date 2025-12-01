import 'package:first_app/main.dart';
import 'package:first_app/quiz_app/quiz.dart';
import 'package:flutter/material.dart';

class AppBackgroundQuiz extends StatefulWidget {
  final List<Widget> children;

  const AppBackgroundQuiz({super.key, required this.children});

  @override
  State<StatefulWidget> createState() {
    return _AppBackgroundQuizState();
  }
}

class _AppBackgroundQuizState extends State<AppBackgroundQuiz> {
  bool isHovering = false;
  double turns = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
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
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...widget.children,
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(206, 95, 93, 93),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RootScaffold(Quiz()),
                    ),
                  );
                },
                icon: AnimatedRotation(
                            turns: turns,
                            duration: const Duration(milliseconds: 500),
                            child: const Icon(
                              Icons.restart_alt,
                              color: Color.fromARGB(255, 242, 245, 245),
                            ),
                          ),

                onHover: (value) => {
                  setState(() {
                    // isHovering = value;
                    turns = value ? 0.5 : 0.0;
                    // isHovering
                    //     ? AnimatedRotation(
                    //         turns: turns,
                    //         duration: const Duration(milliseconds: 2000),
                    //         child: const Icon(
                    //           Icons.restart_alt,
                    //           color: Color.fromARGB(255, 242, 245, 245),
                    //         ),
                    //       )
                    //     : const Icon(
                    //         Icons.restart_alt,
                    //         color: Color.fromARGB(255, 242, 245, 245),
                    //       );
                  })
                },

                label: Text(
                  'Restart Quiz',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 56, 170, 161),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Flutter Demo Home Page');
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
          // width: 100.0, // Set desired width
          // height: 50.0, // Set desired height
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      RootScaffold(Quiz()),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.slowMiddle;

                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
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
            label: const Text('Start Quiz !!!'),
          ),
        ),
        SizedBox(height: heghtScreen * 0.2),
      ],
      // ),
      //   ),
      // ),
    );
  }
}
