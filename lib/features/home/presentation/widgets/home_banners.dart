import 'package:al_waleed/app/routes/route_names.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/features/home/presentation/widgets/live_session_banner.dart';
import 'package:al_waleed/features/home/presentation/widgets/teacher_banner.dart';
import 'package:flutter/material.dart';

class HomeBanners extends StatelessWidget {
  const HomeBanners({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppAnimations.screenSection(
          delay: 250,
          child: const TeacherBanner(),
        ),
        verticalSpace(35),
        AppAnimations.screenSection(
          delay: 450,
          child: LiveSessionBanner(
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteNames.liveSessionScreen,
              );
            },
          ),
        ),
      ],
    );
  }
}