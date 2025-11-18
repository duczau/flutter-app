import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SpringBounceDemo extends StatefulWidget {
  const SpringBounceDemo({super.key});

  @override
  State<SpringBounceDemo> createState() => _SpringBounceDemoState();
}

class _SpringBounceDemoState extends State<SpringBounceDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final SpringDescription _spring = SpringDescription(
    mass: 1,
    stiffness: 10, // độ cứng
    damping: 1,    // giảm dao động
  );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController.unbounded(vsync: this);
    _startSimulation();
  }

  void _startSimulation() {
    final simulation = SpringSimulation(_spring, 0, 1, -2);
    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final position = max(0.0, 1 - _controller.value);
          return Align(
            alignment: Alignment(0, position * 0.9), // di chuyển lên xuống
            child: child,
          );
        },
        child: const Ball(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startSimulation,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Ball extends StatelessWidget {
  const Ball({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
    );
  }
}
