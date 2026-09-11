import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_loading_skeleton.dart';
import 'package:flutter/material.dart';

class LiveSessionLoadingView extends StatelessWidget {
  const LiveSessionLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: LiveSessionLoadingSkeleton(),
    );
  }
}