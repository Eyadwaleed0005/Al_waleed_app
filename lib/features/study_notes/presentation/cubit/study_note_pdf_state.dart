import 'dart:typed_data';

import 'package:al_waleed/core/errors/error_model/app_error_model.dart';

sealed class StudyNotePdfState {
  const StudyNotePdfState();
}

final class StudyNotePdfInitial extends StudyNotePdfState {
  const StudyNotePdfInitial();
}

final class StudyNotePdfLoading extends StudyNotePdfState {
  const StudyNotePdfLoading();
}

final class StudyNotePdfSuccess extends StudyNotePdfState {
  final Uint8List pdfBytes;

  const StudyNotePdfSuccess({
    required this.pdfBytes,
  });
}

final class StudyNotePdfFailure extends StudyNotePdfState {
  final AppErrorModel error;

  const StudyNotePdfFailure({
    required this.error,
  });
}