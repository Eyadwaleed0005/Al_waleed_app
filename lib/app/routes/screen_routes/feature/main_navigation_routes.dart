import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'package:flutter/material.dart';

abstract final class MainNavigationRoutes {
  const MainNavigationRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.mainNavigationScreen:
        final initialIndex = settings.arguments is int
            ? settings.arguments! as int
            : 2;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return MainNavigationScreen(initialIndex: initialIndex);
          },
        );

      default:
        return null;
    }
  }
}
