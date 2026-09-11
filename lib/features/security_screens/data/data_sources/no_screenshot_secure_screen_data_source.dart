import 'package:al_waleed/features/security_screens/data/data_sources/secure_screen_data_source.dart';
import 'package:flutter/services.dart';
import 'package:no_screenshot/no_screenshot.dart';

class NoScreenshotSecureScreenDataSource implements SecureScreenDataSource {
  NoScreenshotSecureScreenDataSource({NoScreenshot? noScreenshot})
    : _noScreenshot = noScreenshot ?? NoScreenshot.instance;

  final NoScreenshot _noScreenshot;

  @override
  Future<void> enableProtection() async {
    final isEnabled = await _noScreenshot.screenshotOff();

    if (!isEnabled) {
      throw PlatformException(code: 'secure-screen-enable-failed');
    }
  }

  @override
  Future<void> disableProtection() async {
    final isDisabled = await _noScreenshot.screenshotOn();

    if (!isDisabled) {
      throw PlatformException(code: 'secure-screen-disable-failed');
    }
  }
}
