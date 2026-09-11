import 'dart:io';

import 'package:al_waleed/features/secure_screen/data/data_sources/secure_screen_data_source.dart';
import 'package:flutter/services.dart';
import 'package:screen_protector/screen_protector.dart';

class ScreenProtectorSecureScreenDataSource
    implements SecureScreenDataSource {
  const ScreenProtectorSecureScreenDataSource();

  static const MethodChannel _pluginChannel = MethodChannel(
    'screen_protector',
  );

  @override
  Future<void> preventScreenshotOn() {
    return ScreenProtector.preventScreenshotOn();
  }

  @override
  Future<void> preventScreenshotOff() {
    return ScreenProtector.preventScreenshotOff();
  }

  @override
  Future<void> preventRecordingOn() async {
    if (Platform.isAndroid) {
      return;
    }
    await _pluginChannel.invokeMethod<void>(
      'preventScreenRecordOn',
    );
  }

  @override
  Future<void> preventRecordingOff() async {
    if (Platform.isAndroid) {
      return;
    }

    await _pluginChannel.invokeMethod<void>(
      'preventScreenRecordOff',
    );
  }
}
