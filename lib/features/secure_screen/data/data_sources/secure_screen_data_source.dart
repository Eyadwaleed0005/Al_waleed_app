abstract class SecureScreenDataSource {
  Future<void> preventScreenshotOn();

  Future<void> preventScreenshotOff();

  Future<void> preventRecordingOn();

  Future<void> preventRecordingOff();
}
