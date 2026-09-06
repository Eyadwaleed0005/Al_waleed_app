import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/features/home/presentation/screens/home_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lessons_screen.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/bottom_navigation_cubit.dart';
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
    return BlocProvider(
      create: (_) => BottomNavigationCubit()..changeIndex(2),
      child: Scaffold(
        extendBody: true,
        backgroundColor: ColorPalette.background,
        body: BlocBuilder<BottomNavigationCubit, int>(
          builder: (context, selectedIndex) {
            final currentIndex = selectedIndex.clamp(0, _screens.length - 1);

            return KeyedSubtree(
              key: ValueKey(currentIndex),
              child: _screens[currentIndex],
            );
          },
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}
