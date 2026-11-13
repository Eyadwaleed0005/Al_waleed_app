import 'dart:math' as math;

import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  final Widget child;

  const LoginBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          width: screenSize.width,
          height: screenSize.height,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [
                  ColorPalette.primaryPressed,
                  ColorPalette.primary,
                  ColorPalette.primarySoftBackground,
                  ColorPalette.highlight,
                ],
                stops: [0.0, 0.4, 0.8, 1.0],
              ),
            ),
            child: const IgnorePointer(
              child: CustomPaint(painter: _ChemicalBackgroundPainter()),
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}

class _ChemicalBackgroundPainter extends CustomPainter {
  const _ChemicalBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 390, size.height / 844);

    final upperPaint = Paint()
      ..color = const Color(0xFFF0E295).withAlpha(38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final lowerPaint = Paint()
      ..color = const Color(0xFF023A22).withAlpha(30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    _drawRing(canvas, const Offset(54, 194), 28, upperPaint);

    const ringRadius = 23.0;
    final ringSpacing = math.sqrt(3) * ringRadius;

    _drawRing(canvas, const Offset(319, 198), ringRadius, upperPaint);

    _drawRing(canvas, Offset(319 + ringSpacing, 198), ringRadius, upperPaint);

    _drawLowerLeftMolecule(canvas, lowerPaint);
    _drawLowerRightMolecule(canvas, lowerPaint);

    canvas.restore();
  }

  void _drawLowerLeftMolecule(Canvas canvas, Paint paint) {
    final branch = Path()
      ..moveTo(22, 767)
      ..lineTo(45, 753)
      ..lineTo(68, 767)
      ..lineTo(92, 753)
      ..lineTo(117, 767)
      ..moveTo(68, 767)
      ..lineTo(68, 741)
      ..lineTo(83, 732)
      ..moveTo(92, 753)
      ..lineTo(106, 738);

    canvas.drawPath(branch, paint);

    canvas.drawLine(const Offset(46, 747), const Offset(62, 757), paint);

    final dotPaint = Paint()..color = paint.color;

    for (final point in const [
      Offset(22, 767),
      Offset(83, 732),
      Offset(117, 767),
    ]) {
      canvas.drawCircle(point, 2.5, dotPaint);
    }
  }

  void _drawLowerRightMolecule(Canvas canvas, Paint paint) {
    const center = Offset(314, 743);
    const radius = 27.0;

    _drawRing(canvas, center, radius, paint);

    final rightVertex = Offset(
      center.dx + radius * math.cos(math.pi / 6),
      center.dy - radius * math.sin(math.pi / 6),
    );

    final sideBranch = Path()
      ..moveTo(rightVertex.dx, rightVertex.dy)
      ..lineTo(355, 733)
      ..lineTo(370, 742)
      ..moveTo(355, 733)
      ..lineTo(355, 719);

    canvas.drawPath(sideBranch, paint);
  }

  void _drawRing(Canvas canvas, Offset center, double radius, Paint paint) {
    final vertices = List<Offset>.generate(6, (index) {
      final angle = -math.pi / 2 + index * math.pi / 3;

      return Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
    });

    final outline = Path()..addPolygon(vertices, true);

    canvas.drawPath(outline, paint);

    for (final index in const [0, 2, 4]) {
      final start = vertices[index];
      final end = vertices[(index + 1) % vertices.length];

      final innerStart = Offset.lerp(center, start, 0.75)!;

      final innerEnd = Offset.lerp(center, end, 0.75)!;

      canvas.drawLine(
        Offset.lerp(innerStart, innerEnd, 0.15)!,
        Offset.lerp(innerStart, innerEnd, 0.85)!,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ChemicalBackgroundPainter oldDelegate) {
    return false;
  }
}
