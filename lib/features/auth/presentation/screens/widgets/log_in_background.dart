import 'package:flutter/material.dart';
import 'package:al_waleed/core/style/app_color.dart';

class LogInBackground extends StatelessWidget {
  final Widget child;

  const LogInBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
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
      child: SafeArea(
        child: child,
      ),
    );
  }
}