import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/live_session/presentation/screens/widgets/live_session_screen_body.dart';
import 'package:flutter/material.dart';

class LiveSessionScreen extends StatelessWidget {
  const LiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "البث المباشر",showBackButton: true,),
      body: LiveSessionScreenBody(),
    );
  }
}