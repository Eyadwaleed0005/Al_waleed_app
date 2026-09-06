import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/features/lesson_quiz/data/data_sources/mock_lesson_quiz_data_source.dart';
import 'package:al_waleed/features/lesson_quiz/data/repositories/lesson_quiz_repository_impl.dart';
import 'package:al_waleed/features/lesson_quiz/domain/use_cases/get_lesson_quiz_use_case.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_state.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_question_screen.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_result_screen.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/screens/lesson_quiz_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Entry point for the Lesson Quiz feature.
///
/// Provides the [LessonQuizCubit] and switches between the three screens
/// (question → result → review) based on the active [QuizPhase].
///
/// All three sub-screens share the same Cubit instance — they never rebuild
/// the Cubit, so state is fully preserved during navigation.
class LessonQuizScreen extends StatelessWidget {
  const LessonQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LessonQuizCubit(
        GetLessonQuizUseCase(
          LessonQuizRepositoryImpl(MockLessonQuizDataSource()),
        ),
      )..loadQuiz(),
      child: BlocBuilder<LessonQuizCubit, LessonQuizState>(
        builder: (context, state) {
          // ── Loading ──────────────────────────────────────────────────
          if (state is LessonQuizInitial || state is LessonQuizLoading) {
            return const Scaffold(
              backgroundColor: ColorPalette.background,
              body: Center(
                child: CircularProgressIndicator(color: ColorPalette.primary),
              ),
            );
          }

          // ── Error ────────────────────────────────────────────────────
          if (state is LessonQuizFailure) {
            return Scaffold(
              backgroundColor: ColorPalette.background,
              body: AppErrorState(
                message: state.message,
                onRetry: () =>
                    context.read<LessonQuizCubit>().loadQuiz(),
              ),
            );
          }

          // ── Active quiz ──────────────────────────────────────────────
          if (state is LessonQuizActive) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _screenForPhase(state.phase),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _screenForPhase(QuizPhase phase) {
    switch (phase) {
      case QuizPhase.question:
        return const LessonQuizQuestionScreen(key: ValueKey('question'));
      case QuizPhase.result:
        return const LessonQuizResultScreen(key: ValueKey('result'));
      case QuizPhase.review:
        return const LessonQuizReviewScreen(key: ValueKey('review'));
    }
  }
}
