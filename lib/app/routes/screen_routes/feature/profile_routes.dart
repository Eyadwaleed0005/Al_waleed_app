import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/features/profile/presentation/screens/about_teacher_screen.dart';
import 'package:al_waleed/features/profile/presentation/screens/my_subscription_screen.dart';
import 'package:al_waleed/features/profile/presentation/screens/personal_info_screen.dart';
import 'package:flutter/material.dart';

abstract final class ProfileRoutes {
  const ProfileRoutes._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.aboutTeacherScreen:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AboutTeacherScreen(),
        );

      case RouteNames.personalInfoScreen:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const PersonalInfoScreen(),
        );

      case RouteNames.mySubscriptionScreen:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const MySubscriptionScreen(),
        );

      default:
        return null;
    }
  }
}
