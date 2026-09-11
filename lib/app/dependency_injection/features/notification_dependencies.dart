import 'package:al_waleed/features/notifications/data/data_sources/local/flutter_local_notification_data_source.dart';
import 'package:al_waleed/features/notifications/data/data_sources/local/local_notification_data_source.dart';
import 'package:al_waleed/features/notifications/data/data_sources/local/notification_topic_local_data_source.dart';
import 'package:al_waleed/features/notifications/data/data_sources/local/secure_notification_topic_local_data_source.dart';
import 'package:al_waleed/features/notifications/data/data_sources/remote/firebase_notification_remote_data_source.dart';
import 'package:al_waleed/features/notifications/data/data_sources/remote/notification_remote_data_source.dart';
import 'package:al_waleed/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:al_waleed/features/notifications/domain/repositories/notification_repository.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/get_initial_notification_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/initialize_notifications_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/show_local_notification_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/stream_foreground_notifications_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/stream_opened_notifications_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/sync_notification_grade_topic_use_case.dart';
import 'package:al_waleed/features/notifications/domain/use_cases/unsubscribe_notification_grade_topic_use_case.dart';
import 'package:al_waleed/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

void registerNotificationDependencies(GetIt getIt) {
  _registerNotificationServices(getIt);
  _registerLocalDataSources(getIt);
  _registerRemoteDataSources(getIt);
  _registerRepositories(getIt);
  _registerUseCases(getIt);
  _registerCubits(getIt);
}

void _registerNotificationServices(GetIt getIt) {
  getIt.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );

  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    FlutterLocalNotificationsPlugin.new,
  );
}

void _registerLocalDataSources(GetIt getIt) {
  getIt.registerLazySingleton<LocalNotificationDataSource>(
    () => FlutterLocalNotificationDataSource(
      localNotificationsPlugin: getIt<FlutterLocalNotificationsPlugin>(),
    ),
  );

  getIt.registerLazySingleton<NotificationTopicLocalDataSource>(
    () => const SecureNotificationTopicLocalDataSource(),
  );
}

void _registerRemoteDataSources(GetIt getIt) {
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => FirebaseNotificationRemoteDataSource(
      firebaseMessaging: getIt<FirebaseMessaging>(),
    ),
  );
}

void _registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: getIt<NotificationRemoteDataSource>(),
      localNotificationDataSource: getIt<LocalNotificationDataSource>(),
      topicLocalDataSource: getIt<NotificationTopicLocalDataSource>(),
    ),
  );
}

void _registerUseCases(GetIt getIt) {
  getIt.registerLazySingleton<InitializeNotificationsUseCase>(
    () => InitializeNotificationsUseCase(
      repository: getIt<NotificationRepository>(),
    ),
  );

  getIt.registerLazySingleton<SyncNotificationGradeTopicUseCase>(
    () => SyncNotificationGradeTopicUseCase(
      repository: getIt<NotificationRepository>(),
    ),
  );

  getIt.registerLazySingleton<UnsubscribeNotificationGradeTopicUseCase>(
    () => UnsubscribeNotificationGradeTopicUseCase(
      repository: getIt<NotificationRepository>(),
    ),
  );

  getIt.registerLazySingleton<StreamForegroundNotificationsUseCase>(
    () => StreamForegroundNotificationsUseCase(
      repository: getIt<NotificationRepository>(),
    ),
  );

  getIt.registerLazySingleton<StreamOpenedNotificationsUseCase>(
    () => StreamOpenedNotificationsUseCase(
      repository: getIt<NotificationRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetInitialNotificationUseCase>(
    () => GetInitialNotificationUseCase(
      repository: getIt<NotificationRepository>(),
    ),
  );

  getIt.registerLazySingleton<ShowLocalNotificationUseCase>(
    () => ShowLocalNotificationUseCase(
      repository: getIt<NotificationRepository>(),
    ),
  );
}

void _registerCubits(GetIt getIt) {
  getIt.registerFactory<NotificationCubit>(
    () => NotificationCubit(
      initializeNotificationsUseCase: getIt<InitializeNotificationsUseCase>(),
      syncNotificationGradeTopicUseCase:
          getIt<SyncNotificationGradeTopicUseCase>(),
      unsubscribeNotificationGradeTopicUseCase:
          getIt<UnsubscribeNotificationGradeTopicUseCase>(),
      streamForegroundNotificationsUseCase:
          getIt<StreamForegroundNotificationsUseCase>(),
      streamOpenedNotificationsUseCase:
          getIt<StreamOpenedNotificationsUseCase>(),
      getInitialNotificationUseCase: getIt<GetInitialNotificationUseCase>(),
      showLocalNotificationUseCase: getIt<ShowLocalNotificationUseCase>(),
    ),
  );
}
