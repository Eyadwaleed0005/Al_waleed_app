import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/features/app_startup/presentation/cubit/app_startup_cubit.dart';
import 'package:al_waleed/features/app_startup/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract final class AppStartupRoutes {
  const AppStartupRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return BlocProvider<AppStartupCubit>(
              create: (_) {
                return getIt<AppStartupCubit>()..initialize();
              },
              child: const SplashScreen(),
            );
          },
        );

      default:
        return null;
    }
  }
}
