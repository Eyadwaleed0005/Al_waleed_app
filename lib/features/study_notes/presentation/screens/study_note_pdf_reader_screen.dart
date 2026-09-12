import 'dart:async';

import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/security_screens/presentation/cubit/secure_screen_cubit.dart';
import 'package:al_waleed/features/security_screens/presentation/widgets/secure_screen_scope.dart';
import 'package:al_waleed/features/study_notes/domain/entities/study_note_entity.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/study_note_pdf_cubit.dart';
import 'package:al_waleed/features/study_notes/presentation/widgets/study_note_pdf_reader_screen_widgets/study_note_pdf_reader_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudyNotePdfReaderScreen extends StatefulWidget {
  final StudyNoteEntity note;

  const StudyNotePdfReaderScreen({
    super.key,
    required this.note,
  });

  @override
  State<StudyNotePdfReaderScreen> createState() =>
      _StudyNotePdfReaderScreenState();
}

class _StudyNotePdfReaderScreenState
    extends State<StudyNotePdfReaderScreen> {
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
        value: AppSystemUi.dark(),
        child: BlocProvider<StudyNotePdfCubit>(
          create: (_) =>
              getIt<StudyNotePdfCubit>()..loadPdf(note: widget.note),
          child: StudyNotePdfReaderContent(note: widget.note),
        ),
      ),
    );
  }
}