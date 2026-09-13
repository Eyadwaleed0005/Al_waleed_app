import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/exams/presentation/cubit/exams_screen_cubit.dart';
import 'package:al_waleed/features/exams/presentation/widgets/exams_screen_widgets/exams_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key, required this.gradeId});
  final String gradeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExamsScreenCubit>(
      create: (_) {
        return getIt<ExamsScreenCubit>()..loadExams(gradeId: gradeId);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.dark(),
        child: const Scaffold(body: ExamsScreenContent()),
      ),
    );
  }
}
