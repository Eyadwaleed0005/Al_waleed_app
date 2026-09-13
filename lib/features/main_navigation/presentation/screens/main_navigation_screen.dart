import 'dart:async';
import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/app_loading_indicator.dart';
import 'package:al_waleed/core/widgets/background/background_student_layout.dart';
import 'package:al_waleed/features/exams/presentation/screens/exams_screen.dart';
import 'package:al_waleed/features/home/presentation/screens/home_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lessons_screen.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/bottom_navigation_cubit.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/student_grade_sync_cubit.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/student_grade_sync_state.dart';
import 'package:al_waleed/features/main_navigation/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:al_waleed/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:al_waleed/features/profile/presentation/screens/profile_screen.dart';
import 'package:al_waleed/features/study_notes/presentation/screens/study_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key, this.initialIndex = 2});

  final int initialIndex;

  static const int _screensCount = 5;
  static const int _examsScreenIndex = 4;

  @override
  Widget build(BuildContext context) {
    final int validInitialIndex = initialIndex.clamp(0, _screensCount - 1);

    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationCubit>(
          create: (_) {
            return BottomNavigationCubit()..changeIndex(validInitialIndex);
          },
        ),
        BlocProvider<StudentGradeSyncCubit>(
          create: (_) {
            return getIt<StudentGradeSyncCubit>()..initialize();
          },
        ),
      ],
      child: BlocListener<StudentGradeSyncCubit, StudentGradeSyncState>(
        listenWhen: _shouldSyncNotificationTopic,
        listener: _syncNotificationTopic,
        child: Scaffold(
          extendBody: true,
          backgroundColor: ColorPalette.background,
          body: BlocBuilder<StudentGradeSyncCubit, StudentGradeSyncState>(
            builder: (BuildContext context, StudentGradeSyncState gradeState) {
              return BlocBuilder<BottomNavigationCubit, int>(
                builder: (BuildContext context, int selectedIndex) {
                  final int currentIndex = selectedIndex.clamp(
                    0,
                    _screensCount - 1,
                  );

                  return KeyedSubtree(
                    key: ValueKey<String>(
                      _screenKey(
                        currentIndex: currentIndex,
                        gradeState: gradeState,
                      ),
                    ),
                    child: _buildScreen(
                      context: context,
                      currentIndex: currentIndex,
                      gradeState: gradeState,
                    ),
                  );
                },
              );
            },
          ),
          bottomNavigationBar: const CustomBottomNavBar(),
        ),
      ),
    );
  }

  Widget _buildScreen({
    required BuildContext context,
    required int currentIndex,
    required StudentGradeSyncState gradeState,
  }) {
    switch (currentIndex) {
      case 0:
        return const ProfileScreen();

      case 1:
        return const StudyNotesScreen();

      case 2:
        return const HomeScreen();

      case 3:
        return const LessonsScreen();

      case _examsScreenIndex:
        return _buildExamsScreen(context: context, gradeState: gradeState);

      default:
        return const HomeScreen();
    }
  }

  Widget _buildExamsScreen({
    required BuildContext context,
    required StudentGradeSyncState gradeState,
  }) {
    return switch (gradeState) {
      StudentGradeSyncSuccess(:final gradeId) => ExamsScreen(gradeId: gradeId),

      StudentGradeSyncFailure(:final error) => BackgroundStudentLayout(
        child: SafeArea(
          child: AppErrorState(
            message: error.message,
            onRetry: context.read<StudentGradeSyncCubit>().retry,
          ),
        ),
      ),

      StudentGradeSyncInitial() ||
      StudentGradeSyncLoading() => const BackgroundStudentLayout(
        child: Center(
          child: AppLoadingIndicator(
            color: ColorPalette.primary,
            size: 34,
            strokeWidth: 4,
            wavelength: 16,
            waveSpeed: 10,
          ),
        ),
      ),
    };
  }

  String _screenKey({
    required int currentIndex,
    required StudentGradeSyncState gradeState,
  }) {
    if (currentIndex != _examsScreenIndex) {
      return currentIndex.toString();
    }

    return switch (gradeState) {
      StudentGradeSyncSuccess(:final gradeId) =>
        '$currentIndex-${gradeId.trim()}',

      _ => '$currentIndex-${gradeState.runtimeType}',
    };
  }

  bool _shouldSyncNotificationTopic(
    StudentGradeSyncState previous,
    StudentGradeSyncState current,
  ) {
    if (current is! StudentGradeSyncSuccess) {
      return false;
    }

    if (previous is! StudentGradeSyncSuccess) {
      return true;
    }

    return previous.gradeId != current.gradeId;
  }

  void _syncNotificationTopic(
    BuildContext context,
    StudentGradeSyncState state,
  ) {
    if (state is! StudentGradeSyncSuccess) {
      return;
    }

    unawaited(
      context.read<NotificationCubit>().syncGradeTopic(gradeId: state.gradeId),
    );
  }
}
