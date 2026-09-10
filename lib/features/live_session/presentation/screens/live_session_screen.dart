import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LiveSessionScreen extends StatelessWidget { 
   final String gradeId;

  const LiveSessionScreen({super.key, required this.gradeId});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child:  Scaffold(
        body: LiveSessionScreenContent(gradeId: gradeId,),
      ),
    );
  }
}