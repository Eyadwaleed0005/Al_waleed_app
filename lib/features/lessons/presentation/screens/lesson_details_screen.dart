import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/connection/cubit/network_status_cubit.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/lessons/domain/entities/lesson_entity.dart';
import 'package:al_waleed/features/lessons/presentation/widgets/lesson_details_screen_widgets/lesson_details_content_screen.dart';
import 'package:al_waleed/features/security_screens/presentation/cubit/secure_screen_cubit.dart';
import 'package:al_waleed/features/security_screens/presentation/widgets/secure_screen_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonDetailsScreen extends StatelessWidget {
  const LessonDetailsScreen({super.key, required this.lesson});

  final LessonEntity lesson;

  @override
  Widget build(BuildContext context) {
    return SecureScreenScope(
      cubit: getIt<SecureScreenCubit>(),
      child: BlocProvider<NetworkStatusCubit>(
        create: (_) {
          return getIt<NetworkStatusCubit>()..startMonitoring();
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppSystemUi.light(),
          child: Scaffold(body: LessonDetailsContentScreen(lesson: lesson)),
        ),
      ),
    );
  }
}
