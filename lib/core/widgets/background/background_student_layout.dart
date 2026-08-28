import 'package:al_waleed/core/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BackgroundStudentLayout extends StatelessWidget {
  const BackgroundStudentLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final topColor = Color.lerp(
          ColorPalette.highlight,
          ColorPalette.accent,
          0.3,
        )!;

        final upperMiddleColor = Color.lerp(
          ColorPalette.paleSage,
          ColorPalette.surface,
          0.55,
        )!;

        final middleColor = Color.lerp(
          ColorPalette.paleSage,
          ColorPalette.surface,
          0.5,
        )!;

        /* final lowerMiddleColor = Color.lerp(
          ColorPalette.surface,
          ColorPalette.secondary,
          0.3,
        )!; */

        final bottomColor = Color.lerp(
          ColorPalette.highlight,
          ColorPalette.surface,
          0.3,
        )!;

        return Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    topColor,
                    upperMiddleColor,
                    middleColor,
                    //lowerMiddleColor,
                    bottomColor,
                  ],
                  stops: const [0, 0.27, 0.7, 1],
                ),
              ),
            ),

            Positioned(
              left: -width * 0.6,
              top: height * 0.4,
              width: width * 1.35,
              height: height * 0.42,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        ColorPalette.secondary.withValues(alpha: 0.3),
                        ColorPalette.secondary.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: -width * 0.6,
              top: height * 0.6,
              width: width * 1.35,
              height: height * 0.42,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        ColorPalette.secondary.withValues(alpha: 0.2),
                        ColorPalette.secondary.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -width * 0.6,
              top: height * 0.7,
              width: width * 1.35,
              height: height * 0.42,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        ColorPalette.secondary.withValues(alpha: 0.1),
                        ColorPalette.secondary.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -width * 0.35,
              top: -height * 0.08,
              width: width,
              height: height * 0.40,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        ColorPalette.primary.withValues(alpha: 0.1),
                        ColorPalette.primary.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: width * 0.2,
              top: height * 0.6,
              width: width * 1.35,
              height: height * 0.42,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        ColorPalette.highlight.withValues(alpha: 0.5),
                        ColorPalette.highlight.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            /* Positioned(
              right: -width * 0.42,
              top: -width * 0.55,
              child: IgnorePointer(
                child: Icon(
                  Icons.radar_outlined,
                  size: width * 1.30,
                  color: ColorPalette.primary.withValues(alpha: 0.035),
                ),
              ),
            ), */
            /* Positioned(
              right: -width * 0.38,
              bottom: -width * 0.40,
              child: IgnorePointer(
                child: Icon(
                  Icons.radar_outlined,
                  size: width * 1.20,
                  color: ColorPalette.warning.withValues(alpha: 0.045),
                ),
              ),
            ), */
            Positioned.fill(
              child: IgnorePointer(
                child: _StudentScienceDecorations(width: width, height: height),
              ),
            ),

            child,
          ],
        );
      },
    );
  }
}

class _StudentScienceDecorations extends StatelessWidget {
  const _StudentScienceDecorations({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: width * 0.055,
          bottom: height * 0.1,
          child: Icon(
            FaIcon(FontAwesomeIcons.atom).icon,
            size: width * 0.1,
            color: ColorPalette.primary.withValues(alpha: 0.13),
          ),
        ),

        Positioned(
          left: width * 0.12,
          bottom: height * 0.8,
          child: Icon(
            FaIcon(FontAwesomeIcons.microscope).icon,
            size: width * 0.07,
            color: ColorPalette.accent.withValues(alpha: 0.50),
          ),
        ),
        Positioned(
          left: width * 0.075,
          bottom: height * 0.255,
          child: Icon(
            FaIcon(FontAwesomeIcons.vials).icon,
            size: width * 0.07,
            color: ColorPalette.highlight.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}
