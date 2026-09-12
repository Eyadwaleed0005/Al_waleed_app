import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/features/live_session/presentation/screens/live_session_screen.dart';
import 'package:flutter/material.dart';

abstract final class LiveSessionRoutes {
  const LiveSessionRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.liveSessionScreen:
        final gradeId = settings.arguments;

        if (gradeId is! String || gradeId.trim().isEmpty) {
          return _buildInvalidArgumentsRoute(settings);
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            return LiveSessionScreen(gradeId: gradeId.trim());
          },
        );

      default:
        return null;
    }
  }

  static MaterialPageRoute<void> _buildInvalidArgumentsRoute(
    RouteSettings settings,
  ) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) {
        return const Scaffold(
          body: Center(child: Text('تعذر فتح البث المباشر')),
        );
      },
    );
  }
}
