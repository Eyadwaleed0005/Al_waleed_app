import 'package:al_waleed/features/app_startup/domain/entities/app_startup_destination.dart';

sealed class AppStartupState {
  const AppStartupState();
}

final class AppStartupInitial extends AppStartupState {
  const AppStartupInitial();
}

final class AppStartupLoading extends AppStartupState {
  const AppStartupLoading();
}

final class AppStartupNavigateToLogin extends AppStartupState {
  const AppStartupNavigateToLogin();
}

final class AppStartupNavigateToHome extends AppStartupState {
  const AppStartupNavigateToHome({required this.gradeId});

  final String gradeId;
}

final class AppStartupUpdateRequired extends AppStartupState {
  const AppStartupUpdateRequired({required this.destination});

  final AppStartupUpdateDestination destination;
}

final class AppStartupSubscriptionExpired extends AppStartupState {
  const AppStartupSubscriptionExpired({required this.destination});

  final AppStartupSubscriptionExpiredDestination destination;
}
