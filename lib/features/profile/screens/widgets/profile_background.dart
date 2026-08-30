import 'package:flutter/material.dart';
import 'package:al_waleed/core/style/app_color.dart';

class ProfileBackground extends StatelessWidget {
  const ProfileBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            ColorPalette.highlight.withValues(
              alpha: 0.6,
            ),
            ColorPalette.secondary.withValues(alpha: 0.25), 
            ColorPalette.highlight.withValues(
              alpha: 0.6,
            ), 
          ],
          stops: const [0.0, 0.6, .88],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
