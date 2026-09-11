import 'dart:math' as math;

import 'package:flutter/material.dart';

class LiveSessionBackground extends StatelessWidget {
  final Widget child;

  const LiveSessionBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFFFFF5CF)),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-1.05, -0.85),
              radius: 1.45,
              colors: [Color(0xFFA5D1DC), Color(0xFFD6E8DD), Color(0x00D6E8DD)],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00FFF5CF),
                  Color(0x1AFFF0B8),
                  Color(0x80FFF0B8),
                ],
                stops: [0.0, 0.62, 1.0],
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const IgnorePointer(
                  child: CustomPaint(
                    painter: _LiveSessionChemicalBackgroundPainter(),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveSessionChemicalBackgroundPainter extends CustomPainter {
  const _LiveSessionChemicalBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bluePaint = Paint()
      ..color = const Color(0xFF28729F).withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final greenPaint = Paint()
      ..color = const Color(0xFF023A22).withValues(alpha: 0.09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final yellowPaint = Paint()
      ..color = const Color(0xFFF0E295).withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    _drawHexagon(canvas, Offset(18, size.height * 0.20), 26, bluePaint);

    _drawHexagon(canvas, Offset(61, size.height * 0.20), 26, bluePaint);

    _drawChemicalChain(
      canvas,
      Offset(size.width - 108, size.height * 0.20),
      greenPaint,
    );

    _drawHexagon(canvas, Offset(48, size.height * 0.84), 28, yellowPaint);

    final bottomRightCenter = Offset(size.width - 70, size.height * 0.84);

    _drawHexagon(canvas, bottomRightCenter, 29, greenPaint);

    _drawInnerBonds(canvas, bottomRightCenter, 20, greenPaint);

    final sideChain = Path()
      ..moveTo(bottomRightCenter.dx + 25, bottomRightCenter.dy - 14)
      ..lineTo(bottomRightCenter.dx + 48, bottomRightCenter.dy - 28)
      ..lineTo(bottomRightCenter.dx + 70, bottomRightCenter.dy - 16);

    canvas.drawPath(sideChain, greenPaint);
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();

    for (int index = 0; index < 6; index++) {
      final angle = (math.pi / 3 * index) - (math.pi / 2);

      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawInnerBonds(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    for (int index = 0; index < 3; index++) {
      final firstAngle = (math.pi / 3 * (index * 2)) - (math.pi / 2);

      final secondAngle = (math.pi / 3 * (index * 2 + 1)) - (math.pi / 2);

      final firstPoint = Offset(
        center.dx + radius * math.cos(firstAngle),
        center.dy + radius * math.sin(firstAngle),
      );

      final secondPoint = Offset(
        center.dx + radius * math.cos(secondAngle),
        center.dy + radius * math.sin(secondAngle),
      );

      canvas.drawLine(firstPoint, secondPoint, paint);
    }
  }

  void _drawChemicalChain(Canvas canvas, Offset start, Paint paint) {
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(start.dx + 23, start.dy - 15)
      ..lineTo(start.dx + 46, start.dy)
      ..lineTo(start.dx + 69, start.dy - 15)
      ..lineTo(start.dx + 92, start.dy);

    canvas.drawPath(path, paint);

    canvas.drawLine(
      Offset(start.dx + 46, start.dy),
      Offset(start.dx + 46, start.dy - 34),
      paint,
    );

    canvas.drawLine(
      Offset(start.dx + 46, start.dy - 34),
      Offset(start.dx + 62, start.dy - 50),
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _LiveSessionChemicalBackgroundPainter oldDelegate,
  ) {
    return false;
  }
}
