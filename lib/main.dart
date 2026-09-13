import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/app/routes/screen_routes/app_routes.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/features/exams/domain/validation/pending_exam_submissions_sync_handler.dart';
import 'package:al_waleed/features/exams/presentation/cubit/pending_exam_submissions_sync_cubit.dart';
import 'package:al_waleed/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:al_waleed/features/notifications/presentation/services/firebase_notification_background_handler.dart';
import 'package:al_waleed/features/notifications/presentation/services/notification_navigation_handler.dart';
import 'package:al_waleed/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseNotificationBackgroundHandler);
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationCubit>(
          create: (_) {
            return getIt<NotificationCubit>()..initialize();
          },
        ),
        BlocProvider<NetworkStatusCubit>(
          create: (_) {
            return getIt<NetworkStatusCubit>()..startMonitoring();
          },
        ),
        BlocProvider<PendingExamSubmissionsSyncCubit>(
          create: (_) {
            return getIt<PendingExamSubmissionsSyncCubit>()..initialize();
          },
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'الوليد',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(),
            initialRoute: RouteNames.splashScreen,
            onGenerateRoute: AppRoutes.generateRoute,
            builder: (BuildContext context, Widget? appChild) {
              return PendingExamSubmissionsSyncHandler(
                child: NotificationNavigationHandler(
                  navigatorKey: navigatorKey,
                  child: appChild ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
