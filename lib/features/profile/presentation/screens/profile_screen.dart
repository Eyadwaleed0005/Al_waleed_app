import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light(),
      child: BlocProvider(
        create: (_) => getIt<ProfileCubit>()..getStudentProfile(),
        child: const Scaffold(body: ProfileScreenContent()),
      ),
    );
  }
}
