import 'package:al_waleed/app/routes/app_images_routes.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lessons_cubit.dart';
import 'package:al_waleed/features/lessons/presentation/cubit/lessons_state.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lessons_screen_states/lessons_empty_view.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lessons_screen_states/lessons_error_view.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lessons_screen_states/lessons_loading_view.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_screen_widgets/lessons_screen_states/lessons_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonsScreenContent extends StatelessWidget {
  const LessonsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundStudentLayout(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              CustomAppBar(
                title: 'الدروس',
                showBackButton: true,
                backgroundColor: Colors.transparent,
                actions: [
                  Image.asset(
                    AppImage().bookOpenBig,
                    width: 28.w,
                    height: 28.h,
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<LessonsCubit, LessonsState>(
                  builder: (context, state) {
                    if (state is LessonsInitial ||
                        state is LessonsLoading) {
                      return const LessonsLoadingView();
                    }
                    if (state is LessonsFailure) {
                      return LessonsErrorView(
                        errorMessage: state.error.message,
                        onRetry: context.read<LessonsCubit>().retry,
                      );
                    }
                    if (state is LessonsEmpty) {
                      return const LessonsEmptyView();
                    }
                    if (state is LessonsDataSuccess) {
                      return LessonsSuccessView(
                        lessons: state.lessons,
                        query: state.query,
                        hasNoResults: state.hasNoResults,
                        onLessonTap: (lesson) {
                          Navigator.of(context).pushNamed(
                            RouteNames.lessonDetails,
                            arguments: lesson,
                          );
                        },
                        onSearchChanged: context.read<LessonsCubit>().search,
                        onSearchClear: () =>
                            context.read<LessonsCubit>().search(''),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
