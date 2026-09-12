abstract interface class AppStartupLocalDataSource {
  String? getCurrentUserId();

  Future<int> getInstalledBuildNumber();
}