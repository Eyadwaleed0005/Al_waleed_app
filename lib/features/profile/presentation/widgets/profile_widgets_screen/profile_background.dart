import 'dart:math' as math;

import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';

class ProfileBackground extends StatelessWidget {
  final Widget child;

  const ProfileBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              ColorPalette.highlight.withValues(alpha: 0.6),
              ColorPalette.secondary.withValues(alpha: 0.25),
              ColorPalette.highlight.withValues(alpha: 0.6),
            ],
            stops: const [0.0, 0.6, 0.88],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _ProfileChemicalPainter()),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _ProfileChemicalPainter extends CustomPainter {
  const _ProfileChemicalPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 390, size.height / 844);

    final topLeftPaint = _createPaint(
      ColorPalette.primary.withValues(alpha: 0.10),
    );

    final topRightPaint = _createPaint(
      ColorPalette.textOceanBlue.withValues(alpha: 0.10),
    );

    final bottomLeftPaint = _createPaint(
      ColorPalette.highlight.withValues(alpha: 0.28),
    );

    final bottomRightPaint = _createPaint(
      ColorPalette.primary.withValues(alpha: 0.10),
    );

    _drawTopLeftMolecule(canvas, topLeftPaint);

    _drawRing(canvas, const Offset(320, 185), 27, topRightPaint);

    _drawConnectedRings(canvas, const Offset(20, 755), 26, bottomLeftPaint);

    _drawRing(canvas, const Offset(340, 735), 27, bottomRightPaint);

    canvas.restore();
  }

  Paint _createPaint(Color color) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  void _drawTopLeftMolecule(Canvas canvas, Paint paint) {
    final path = Path()
      ..moveTo(10, 199)
      ..lineTo(34, 184)
      ..lineTo(58, 198)
      ..lineTo(81, 184)
      ..lineTo(104, 198)
      ..moveTo(58, 198)
      ..lineTo(58, 171)
      ..lineTo(74, 162)
      ..moveTo(81, 184)
      ..lineTo(96, 168);

    canvas.drawPath(path, paint);

    canvas.drawLine(const Offset(36, 178), const Offset(53, 188), paint);
  }

  void _drawConnectedRings(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final spacing = math.sqrt(3) * radius;

    _drawRing(canvas, center, radius, paint);

    _drawRing(canvas, Offset(center.dx + spacing, center.dy), radius, paint);
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
  bool shouldRepaint(covariant _ProfileChemicalPainter oldDelegate) {
    return false;
  }
}
