import 'package:flutter/material.dart';
import 'package:al_waleed/core/style/app_color.dart';

class LiveSessionBackground extends StatelessWidget {
  final Widget child;

  const LiveSessionBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorPalette.highlight.withValues(alpha: 0.5),
            ColorPalette.secondary.withValues(alpha: 0.18),
            ColorPalette.paleSage.withValues(alpha: 0.7),
            ColorPalette.highlight.withValues(alpha: 0.7),
          ],
          stops: const [0.0, 0.35, 0.7, 1.0],
        ),
      ),
      child: Stack(children: [child]),
    );
  }
}
