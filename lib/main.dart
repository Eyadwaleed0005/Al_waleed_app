import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/app/routes/app_routes.dart';
import 'package:al_waleed/app/routes/route_names.dart';
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
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    return BlocProvider<NotificationCubit>(
      create: (_) => getIt<NotificationCubit>()..initialize(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'الوليد',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(),
            initialRoute: RouteNames.loginScreen,
            onGenerateRoute: AppRoutes.generateRoute,
            builder: (context, appChild) {
              return NotificationNavigationHandler(
                navigatorKey: navigatorKey,
                child: appChild ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
