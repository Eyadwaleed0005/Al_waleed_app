import 'package:al_waleed/features/app_startup/domain/entities/app_version_entity.dart';

sealed class AppStartupDestination {
  const AppStartupDestination();
}

final class AppStartupLoginDestination
    extends AppStartupDestination {
  const AppStartupLoginDestination();
}

final class AppStartupHomeDestination
    extends AppStartupDestination {
  final String gradeId;

  const AppStartupHomeDestination({
    required this.gradeId,
  });
}

final class AppStartupUpdateDestination
    extends AppStartupDestination {
  final AppVersionEntity version;
  final int installedBuildNumber;

  const AppStartupUpdateDestination({
    required this.version,
    required this.installedBuildNumber,
  });

  bool get isForced {
    return version.forceUpdate;
  }
}

final class AppStartupSubscriptionExpiredDestination
    extends AppStartupDestination {
  final DateTime subscriptionEndAt;

  const AppStartupSubscriptionExpiredDestination({
    required this.subscriptionEndAt,
  });
}