import 'package:al_waleed/features/study_notes/domain/use_case/get_study_notes_use_case.dart';
import 'package:al_waleed/features/study_notes/presentation/cubit/view_notes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewNotesCubit extends Cubit<ViewNotesState> {
  ViewNotesCubit(this._getStudyNotesUseCase)
      : super(const ViewNotesInitial());

  final GetStudyNotesUseCase _getStudyNotesUseCase;

  Future<void> loadNotes() async {
    emit(const ViewNotesLoading());
    try {
      final notes = await _getStudyNotesUseCase();
      emit(ViewNotesLoaded(notes));
    } catch (e) {
      emit(ViewNotesFailure(e.toString()));
    }
  }
}
