import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/home/presentation/widgets/home_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: const Scaffold(body: HomeScreenContent()),
    );
  }
}
