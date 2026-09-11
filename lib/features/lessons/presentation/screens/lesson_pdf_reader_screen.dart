import 'dart:async';

import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lesson_pdf_cubit.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_pdf_reader_screen_widgets/lesson_pdf_reader_content.dart';
import 'package:al_waleed/features/security_screens/presentation/cubit/secure_screen_cubit.dart';
import 'package:al_waleed/features/security_screens/presentation/widgets/secure_screen_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonPdfReaderScreen extends StatefulWidget {
  final LessonEntity lesson;

  const LessonPdfReaderScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonPdfReaderScreen> createState() => _LessonPdfReaderScreenState();
}

class _LessonPdfReaderScreenState
    extends State<LessonPdfReaderScreen> {
  @override
  void initState() {
    super.initState();

    unawaited(
      SystemChrome.setPreferredOrientations(
        const [
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      ),
    );
  }

  @override
  void dispose() {
    unawaited(
      SystemChrome.setPreferredOrientations(
        const [
          DeviceOrientation.portraitUp,
        ],
      ),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SecureScreenScope(
      cubit: getIt<SecureScreenCubit>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: BlocProvider<LessonPdfCubit>(
          create: (_) =>
              getIt<LessonPdfCubit>()..loadPdf(lesson: widget.lesson),
          child: LessonPdfReaderContent(lesson: widget.lesson),
        ),
      ),
    );
  }
}