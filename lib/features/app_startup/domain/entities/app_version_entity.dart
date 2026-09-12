class AppVersionEntity {
  final String latestVersion;
  final int latestBuildNumber;
  final String storeUrl;
  final bool forceUpdate;

  const AppVersionEntity({
    required this.latestVersion,
    required this.latestBuildNumber,
    required this.storeUrl,
    required this.forceUpdate,
  });

  bool hasNewerVersion({
    required int installedBuildNumber,
  }) {
    return latestBuildNumber > installedBuildNumber;
  }
}