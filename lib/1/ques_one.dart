import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Single_Pendulum extends StatefulWidget {
  const Single_Pendulum({super.key});

  @override
  State<Single_Pendulum> createState() => _Single_PendulumState();
}

class _Single_PendulumState extends State<Single_Pendulum>
    with SingleTickerProviderStateMixin {
  final double length = 200;
  final double gravity = 9.8;
  final double theta0 = pi / 4;
  late Ticker _ticker;
  double value = 0;
  @override
  void initState() {
    super.initState();
    _ticker = Ticker((Duration elapsed) {
      setState(() {
        value = elapsed.inMilliseconds / 1000 * 15;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Offset calculatePendulumPosition({
    required double length,
    required double gravity,
    required double theta0,
    required double time,
    Offset? anchorPoint,
  }) {
    anchorPoint ??= const Offset(0, 0);

    double omega = sqrt(gravity / length);

    double theta = theta0 * cos(omega * time);

    double x = length * sin(theta);
    double y = length * cos(theta);

    return Offset(anchorPoint.dx + x, anchorPoint.dy + y);
  }

// tính toán vị trí con lắc ( có lực cản )
  Offset calculateDampedPendulumPosition({
    required double length,
    required double gravity,
    required double theta0,
    required double time,
    required double dampingFactor,
    Offset? anchorPoint,
  }) {
    anchorPoint ??= const Offset(0, 0);

    double omega = sqrt(gravity / length);

    double theta = theta0 * exp(-dampingFactor * time) * cos(omega * time);

    double x = length * sin(theta);
    double y = length * cos(theta);

    return Offset(anchorPoint.dx + x, anchorPoint.dy + y);
  }

  @override
  Widget build(BuildContext context) {
    Offset offset = calculateDampedPendulumPosition(
        gravity: gravity,
        length: 200,
        theta0: theta0,
        time: value,
        dampingFactor: 0.0075);
    return Scaffold(
      body: Center(
          child: CustomPaint(
        size: const Size(400, 400),
        painter: PendulumPainter(x: offset.dx, y: offset.dy),
      )),
    );
  }
}

class PendulumPainter extends CustomPainter {
  final double x, y;

  PendulumPainter({required this.x, required this.y});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 4;

    final pendulumX = centerX + x;
    final pendulumY = centerY + y;

    final paintLine = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(pendulumX, pendulumY),
      paintLine,
    );

    final paintCircle = Paint()..color = Colors.red;
    canvas.drawCircle(Offset(pendulumX, pendulumY), 20, paintCircle);

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.3, centerY),
      Offset(size.width * 0.7, centerY),
      paint,
    );

    final arcPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCircle(
      center: Offset(centerX, centerY),
      radius: size.height / 2,
    );

    canvas.drawArc(
      rect,
      pi / 4,
      pi / 2,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
