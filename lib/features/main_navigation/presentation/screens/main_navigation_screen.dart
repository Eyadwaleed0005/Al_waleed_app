import 'package:al_waleed/features/home/presentation/screens/home_screen.dart';
import 'package:al_waleed/features/lessons/presentation/screens/lessons_screen.dart';
import 'package:al_waleed/features/main_navigation/presentation/cubit/bottom_navigation_cubit.dart';
import 'package:al_waleed/features/main_navigation/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:al_waleed/features/study_notes/presentation/screens/view_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  static const List<Widget> _screens = [ViewNotesScreen(), ViewNotesScreen(), ViewNotesScreen(), LessonsScreen(), HomeScreen()];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavigationCubit()..changeIndex(4), // Default to الرئيسية (Index 4)
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: BlocBuilder<BottomNavigationCubit, int>(
          builder: (context, selectedIndex) {
            return IndexedStack(index: selectedIndex.clamp(0, _screens.length - 1), children: _screens);
          },
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}
