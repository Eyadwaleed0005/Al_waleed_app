import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/start_exam_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StartExamScreen extends StatelessWidget {
  const StartExamScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: Scaffold(body: StartExamScreenContent()),
    );
  }
}
