import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/exams/presentation/widgets/current_exam_widgets/exams_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark(),
      child: Scaffold(body: ExamsScreenContent(isEmpty: false)),
    );
  }
}
