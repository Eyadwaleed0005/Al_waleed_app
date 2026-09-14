import 'package:flutter/material.dart';

class LessonPdfStateLayout extends StatelessWidget {
  const LessonPdfStateLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.orientationOf(context) ==
        Orientation.landscape;

    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (isLandscape) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 6,
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 360,
                    child: child,
                  ),
                ),
              ),
            );
          }

          final availableHeight =
              constraints.maxHeight > 48
                  ? constraints.maxHeight - 48
                  : 0.0;

          return SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: availableHeight,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 520,
                  ),
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}