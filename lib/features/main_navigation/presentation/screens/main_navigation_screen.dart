import 'dart:async';

import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/style/app_color.dart';
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
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 2});

  static const List<Widget> _screens = [
    ProfileScreen(),
    StudyNotesScreen(),
    HomeScreen(),
    LessonsScreen(),
    // مؤقتًا لحين انتهاء فيتشر الامتحانات.
    StudyNotesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final validInitialIndex = initialIndex.clamp(0, _screens.length - 1);

    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationCubit>(
          create: (_) =>
              BottomNavigationCubit()..changeIndex(validInitialIndex),
        ),
        BlocProvider<StudentGradeSyncCubit>(
          create: (_) => getIt<StudentGradeSyncCubit>()..initialize(),
        ),
      ],
      child: BlocListener<StudentGradeSyncCubit, StudentGradeSyncState>(
        listenWhen: _shouldSyncNotificationTopic,
        listener: _syncNotificationTopic,
        child: Scaffold(
          extendBody: true,
          backgroundColor: ColorPalette.background,
          body: BlocBuilder<StudentGradeSyncCubit, StudentGradeSyncState>(
            builder: (context, gradeState) {
              final gradeId = switch (gradeState) {
                StudentGradeSyncSuccess state => state.gradeId,
                _ => 'grade-not-loaded',
              };

              return BlocBuilder<BottomNavigationCubit, int>(
                builder: (context, selectedIndex) {
                  final currentIndex = selectedIndex.clamp(
                    0,
                    _screens.length - 1,
                  );

                  return KeyedSubtree(
                    key: ValueKey('$currentIndex-$gradeId'),
                    child: _screens[currentIndex],
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
