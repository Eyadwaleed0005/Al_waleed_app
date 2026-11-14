import 'dart:math' as math;

import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingBottomSectionBackground extends StatelessWidget {
  const OnboardingBottomSectionBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: EdgeInsets.only(top: 68.h),
          child: child,
        )
        .animate(onPlay: (controller) => controller.repeat())
        .custom(
          duration: const Duration(seconds: 5),
          curve: Curves.linear,
          builder: (context, value, child) {
            final phase = value * 2 * math.pi;

            return Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  top: -24.h,
                  child: ClipPath(
                    clipper: _WaveClipper(phase: phase, waveHeight: 56.h),
                    child: const ColoredBox(color: ColorPalette.paleSage),
                  ),
                ),
                Positioned.fill(
                  top: -24.h,
                  child: ClipPath(
                    clipper: _WaveClipper(
                      phase: phase,
                      waveHeight: 56.h,
                      topOffset: 12.h,
                    ),
                    child: const ColoredBox(color: ColorPalette.primary),
                  ),
                ),
                child,
              ],
            );
          },
        );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  const _WaveClipper({
    required this.phase,
    required this.waveHeight,
    this.topOffset = 0,
  });

  final double phase;
  final double waveHeight;
  final double topOffset;

  @override
  Path getClip(Size size) {
    final path = Path();

    for (var i = 0; i <= 80; i++) {
      final progress = i / 80;
      final x = size.width * progress;
      final y =
          topOffset +
          waveHeight / 2 +
          math.sin(progress * 2 * math.pi - phase) * waveHeight / 2;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    return path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _WaveClipper oldClipper) {
    return phase != oldClipper.phase ||
        waveHeight != oldClipper.waveHeight ||
        topOffset != oldClipper.topOffset;
  }
}
