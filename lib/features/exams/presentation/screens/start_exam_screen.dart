import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/exams/domain/entities/student_exam_session_entity.dart';
import 'package:al_waleed/features/exams/presentation/cubit/start_exam_screen_cubit.dart';
import 'package:al_waleed/features/exams/presentation/widgets/start_exam_widgets/start_exam_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartExamScreen extends StatelessWidget {
  const StartExamScreen({super.key, required this.session});

  final StudentExamSessionEntity session;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StartExamScreenCubit>(
      create: (_) {
        return getIt<StartExamScreenCubit>()..initialize(session: session);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.dark(),
        child: const Scaffold(body: StartExamScreenContent()),
      ),
    );
  }
}
