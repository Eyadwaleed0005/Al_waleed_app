import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract final class DevicePreviewService {
  DevicePreviewService._();
  static const bool enabled = false;

  static bool get isEnabled {
    return enabled && kDebugMode;
  }

  static void run({required Widget child}) {
    runApp(_wrapApp(child: child));
  }

  static Widget _wrapApp({required Widget child}) {
    if (!isEnabled) {
      return child;
    }

    return DevicePreview(
      enabled: true,
      builder: (BuildContext context) {
        return child;
      },
    );
  }

  static Locale? locale(BuildContext context) {
    if (!isEnabled) {
      return null;
    }

    return DevicePreview.locale(context);
  }

  static Widget appBuilder(BuildContext context, Widget? child) {
    final Widget currentChild = child ?? const SizedBox.shrink();

    if (!isEnabled) {
      return currentChild;
    }

    return DevicePreview.appBuilder(context, currentChild);
  }
}
