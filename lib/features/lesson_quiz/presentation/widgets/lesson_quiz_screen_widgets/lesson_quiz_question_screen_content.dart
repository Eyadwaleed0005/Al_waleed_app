import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_state/lesson_quiz_empty_view.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_state/lesson_quiz_error_view.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_state/lesson_quiz_loading_view.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_state/lesson_quiz_success_view.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonQuizQuestionScreenContent extends StatelessWidget {
  const LessonQuizQuestionScreenContent({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: BlocBuilder<LessonQuizCubit, LessonQuizState>(
        builder: (context, state) {
          if (state is LessonQuizFailure) {
            return _buildStateWithHeader(
              child: LessonQuizErrorView(
                errorMessage: state.error.message,
                onRetry: () => _retryLoading(context),
              ),
            );
          }

          if (state is LessonQuizSuccess) {
            if (state.quiz.questions.isEmpty) {
              return _buildStateWithHeader(child: const LessonQuizEmptyView());
            }

            return LessonQuizSuccessView(quiz: state.quiz);
          }

          return const LessonQuizLoadingView();
        },
      ),
    );
  }

  Widget _buildStateWithHeader({required Widget child}) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const QuizHeader(title: 'اختبار الدرس', showBackButton: true),
      body: SafeArea(top: false, child: child),
    );
  }

  void _retryLoading(BuildContext context) {
    context.read<LessonQuizCubit>().loadLessonQuiz(lessonId: lessonId);
  }
}
