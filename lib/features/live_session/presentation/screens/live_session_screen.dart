import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/live_session/presentation/cubits/live_session_cubit/live_session_cubit.dart';
import 'package:al_waleed/features/live_session/presentation/widgets/live_session_screen_widgets/live_session_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveSessionScreen extends StatelessWidget {
  final String gradeId;

  const LiveSessionScreen({
    super.key,
    required this.gradeId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LiveSessionCubit>()
        ..getLiveSession(
          gradeId: gradeId,
        ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.light(),
        child: Scaffold(
          body: LiveSessionScreenContent(
            gradeId: gradeId,
          ),
        ),
      ),
    );
  }
}