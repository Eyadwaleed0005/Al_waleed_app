import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/core/widgets/custom_app_card.dart';
import 'package:flutter/material.dart';

class TeacherBanner extends StatelessWidget {
  const TeacherBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 350 / 180,
      child: CustomAppCard(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.zero,
        child: Image.asset(
          AppImage().teacherBanner,
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}