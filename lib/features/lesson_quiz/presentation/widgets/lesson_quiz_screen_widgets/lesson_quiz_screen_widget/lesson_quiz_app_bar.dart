import 'package:al_waleed/core/helper/arabic_numbers_helper.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/cubit/lesson_quiz_session_cubit.dart';
import 'package:al_waleed/features/lesson_quiz/presentation/widgets/lesson_quiz_screen_widgets/lesson_quiz_screen_widget/quiz_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonQuizAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LessonQuizAppBar({super.key});

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonQuizSessionCubit, LessonQuizSessionState>(
      builder: (context, state) {
        final question = state.currentQuestion;

        final badge = question == null
            ? null
            : QuizProgressBadge(
                text: '${toArabicNumbers(question.score)} درجات',
              );

        return QuizHeader(title: 'اختبار الدرس', trailingBadge: badge);
      },
    );
  }
}
