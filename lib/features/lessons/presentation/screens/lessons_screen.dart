import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lessons_cubit.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lessons_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LessonsCubit>()..initialize(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: const Scaffold(body: LessonsScreenContent()),
      ),
    );
  }
}
