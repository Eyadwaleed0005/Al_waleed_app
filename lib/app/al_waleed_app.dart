import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/app/routes/screen_routes/app_routes.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/services/device_preview_service.dart';
import 'package:al_waleed/features/exams/domain/validation/pending_exam_submissions_sync_handler.dart';
import 'package:al_waleed/features/exams/presentation/cubit/pending_exam_submissions_sync_cubit.dart';
import 'package:al_waleed/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:al_waleed/features/notifications/presentation/services/notification_navigation_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlWaleedApp extends StatelessWidget {
  const AlWaleedApp({super.key});

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
            useInheritedMediaQuery: true,
            locale: DevicePreviewService.locale(context),
            theme: ThemeData(),
            initialRoute: RouteNames.splashScreen,
            onGenerateRoute: AppRoutes.generateRoute,
            builder: _buildApp,
          );
        },
      ),
    );
  }

  Widget _buildApp(BuildContext context, Widget? child) {
    final Widget previewedChild = DevicePreviewService.appBuilder(
      context,
      child,
    );

    return PendingExamSubmissionsSyncHandler(
      child: NotificationNavigationHandler(
        navigatorKey: navigatorKey,
        child: previewedChild,
      ),
    );
  }
}
