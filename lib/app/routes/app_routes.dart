import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/features/auth/presentation/screens/login_view.dart';
import 'package:al_waleed/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  const AppRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (context) => const LogInView());
      default:
        return null;
    }
  }
}
