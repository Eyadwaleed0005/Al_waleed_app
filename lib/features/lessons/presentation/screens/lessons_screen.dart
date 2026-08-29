import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lessons_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: AppSystemUi.light(),
    child: Scaffold(body: LessonsScreenContent(isEmpty: false)),
  );
}
