import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_details_content_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LessonDetailsScreen extends StatelessWidget {
  const LessonDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: AppSystemUi.light(),
    child: Scaffold(body: LessonDetailsContentScreen()),
  );
}
