abstract interface class AppStartupLocalDataSource {
  String? getCurrentUserId();

  Future<bool> hasCompletedOnboarding();

  Future<void> completeOnboarding();

  Future<int> getInstalledBuildNumber();
}
