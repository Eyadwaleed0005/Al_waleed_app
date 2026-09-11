import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/features/home/presentation/screens/home_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lessons_screen.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/bottom_navigation_cubit.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/student_grade_sync_cubit.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/student_grade_sync_state.dart';
import 'package:al_waleed/features/main_navigation/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:al_waleed/features/profile/presentation/screens/profile_screen.dart';
import 'package:al_waleed/features/study_notes/presentation/screens/study_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  static const List<Widget> _screens = [
    ProfileScreen(),
    StudyNotesScreen(),
    HomeScreen(),
    LessonsScreen(),
    StudyNotesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationCubit>(
          create: (_) {
            return getIt<BottomNavigationCubit>()..changeIndex(2);
          },
        ),
        BlocProvider<StudentGradeSyncCubit>(
          create: (_) {
            return getIt<StudentGradeSyncCubit>()..initialize();
          },
        ),
      ],
      child: Scaffold(
        extendBody: true,
        backgroundColor: ColorPalette.background,
        body: BlocBuilder<BottomNavigationCubit, int>(
          builder: (context, selectedIndex) {
            final currentIndex = selectedIndex
                .clamp(0, _screens.length - 1)
                .toInt();

            return BlocBuilder<StudentGradeSyncCubit, StudentGradeSyncState>(
              buildWhen: _shouldRebuildForGradeChange,
              builder: (context, gradeState) {
                final gradeId = switch (gradeState) {
                  StudentGradeSyncSuccess state => state.gradeId,
                  _ => 'cached-grade',
                };

                return KeyedSubtree(
                  key: ValueKey('main-screen-$currentIndex-$gradeId'),
                  child: _screens[currentIndex],
                );
              },
            );
          },
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }

  static bool _shouldRebuildForGradeChange(
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
}
