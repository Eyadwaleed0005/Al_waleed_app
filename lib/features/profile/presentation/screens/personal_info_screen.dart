import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/core/helper/app_system_ui.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/features/profile/presentation/cubit/personal_info_cubit/personal_info_cubit.dart';
import 'package:al_waleed/features/profile/presentation/widgets/personal_info_widgets/personal_info_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PersonalInfoCubit>()..initialize(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppSystemUi.dark(),
        child: const Scaffold(
          backgroundColor: ColorPalette.background,
          body: PersonalInfoScreenContent(),
        ),
      ),
    );
  }
}
