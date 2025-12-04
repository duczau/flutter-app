import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressWithText extends StatefulWidget {
  final double percentage;
  const CircularProgressWithText(this.percentage, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _CircularProgressWithTextState();
  }
}

class _CircularProgressWithTextState extends State<CircularProgressWithText> {
  Timer? timer;
  late double percentage;

  @override
  void initState() {
    super.initState();
    percentage = widget.percentage;
    _startCounting();
  }

  void _startCounting() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (percentage < 90) {
          percentage += 1.5;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CircularProgressPainter(percentage),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: OutlinedText(percentage),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double percentage;

  _CircularProgressPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, paint);

    final progressPaint = Paint()
      ..strokeWidth = 10
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double arcAngle = 2 * pi * (percentage / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class OutlinedText extends StatefulWidget {
  final double percentage;
  const OutlinedText(this.percentage, {super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _OutlinedTextState();
  }
}

class _OutlinedTextState extends State<OutlinedText> {
  
  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.black.withOpacity(0.5);

    final textStyle = TextStyle(
      shadows: [
        Shadow(
          color: primaryColor,
          blurRadius: 5,
          offset: const Offset(0, 0),
        )
      ],
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          '${widget.percentage.toInt()}%',
          style: textStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..color = primaryColor
              ..strokeWidth = 2,
            color: null,
          ),
        ),
        Text('${widget.percentage.toInt()}%', style: textStyle),
      ],
    );
  }
}