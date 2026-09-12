import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:al_waleed/features/authentication/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract final class AuthenticationRoutes {
  const AuthenticationRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.loginScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return BlocProvider<LoginCubit>(
              create: (_) => getIt<LoginCubit>(),
              child: const LoginScreen(),
            );
          },
        );

      default:
        return null;
    }
  }
}
