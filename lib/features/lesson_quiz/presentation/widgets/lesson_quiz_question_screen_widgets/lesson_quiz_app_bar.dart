
import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_question_screen_widgets/quiz_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonQuizAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LessonQuizAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final state = context.watch<LessonQuizCubit>().state;
        Widget? badge;

        if (state is LessonQuizSuccess && state.questions.isNotEmpty) {
          final question = state.questions[state.currentIndex];
          badge = QuizProgressBadge(
            text: '${toArabicNumbers(question.questionScore)} درجات',
          );
        }

        return QuizHeader(title: 'اختبار الدرس', trailingBadge: badge);
      },
    );
  }
}
