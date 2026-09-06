import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_screen_content.dart';
import 'package:flutter/material.dart';

class LiveSessionScreen extends StatelessWidget {
  const LiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LiveSessionScreenContent(),
    );
  }
}