import 'dart:async';

import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

OverlayEntry? _exitToastEntry;

void showExitAppToast(
  BuildContext context, {
  Duration duration = const Duration(seconds: 2),
}) {
  dismissExitAppToast();

  late final OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => ExitAppToast(
      duration: duration,
      onDismiss: () {
        if (identical(_exitToastEntry, entry)) {
          dismissExitAppToast();
        }
      },
    ),
  );

  _exitToastEntry = entry;

  Overlay.of(context, rootOverlay: true).insert(entry);
}

void dismissExitAppToast() {
  final entry = _exitToastEntry;
  _exitToastEntry = null;

  if (entry == null) {
    return;
  }

  if (entry.mounted) {
    entry.remove();
  }

  entry.dispose();
}

class ExitAppToast extends StatefulWidget {
  const ExitAppToast({
    super.key,
    required this.duration,
    required this.onDismiss,
  });

  final Duration duration;
  final VoidCallback onDismiss;

  @override
  State<ExitAppToast> createState() => _ExitAppToastState();
}

class _ExitAppToastState extends State<ExitAppToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      reverseDuration: const Duration(milliseconds: 150),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    _controller.forward();

    _dismissTimer = Timer(widget.duration, () async {
      if (!mounted) {
        return;
      }

      await _controller.reverse();

      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 320.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorPalette.textPrimary.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        'اضغط رجوع مرة أخرى للخروج',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: AppTextStyle.font15SurfaceMediumTajawal(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
