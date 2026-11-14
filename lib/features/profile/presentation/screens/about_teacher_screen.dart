import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/features/profile/presentation/widgets/about_teacher_screen_widgets/about_teacher_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutTeacherScreen extends StatelessWidget {
  const AboutTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: const Scaffold(
        backgroundColor: ColorPalette.background,
        body: AboutTeacherScreenContent(),
      ),
    );
  }
}