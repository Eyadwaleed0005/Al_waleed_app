import 'package:al_waleed/app/dependency_injection/core_dependencies.dart';
import 'package:al_waleed/app/dependency_injection/features/authentication_dependencies.dart';
import 'package:al_waleed/app/dependency_injection/features/live_session_dependencies.dart';
import 'package:al_waleed/app/dependency_injection/features/main_navigation_dependencies.dart';
import 'package:al_waleed/app/dependency_injection/features/notification_dependencies.dart';
import 'package:al_waleed/app/dependency_injection/features/profile_dependencies.dart';
import 'package:al_waleed/app/dependency_injection/features/secure_screen_dependencies.dart';
import 'package:al_waleed/app/dependency_injection/features/study_notes_dependencies.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  registerCoreDependencies(getIt);
  registerAuthenticationDependencies(getIt);
  registerMainNavigationDependencies(getIt);
  registerSecureScreenDependencies(getIt);
  registerStudyNotesDependencies(getIt);
  registerLiveSessionDependencies(getIt);
  registerProfileDependencies(getIt);
  registerNotificationDependencies(getIt);
}