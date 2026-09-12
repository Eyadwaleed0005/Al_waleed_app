import 'package:al_waleed/app/dependency_injection/service_locator.dart';
import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/cache/secure_storage/secure_storage.dart';
import 'package:al_waleed/core/cache/secure_storage/secure_storage_keys.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/features/home/presentation/widgets/live_session_banner.dart';
import 'package:al_waleed/features/home/presentation/widgets/teacher_banner.dart';
import 'package:al_waleed/features/live_session/presentation/cubits/live_session_cubit/live_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBanners extends StatefulWidget {
  const HomeBanners({super.key});

  @override
  State<HomeBanners> createState() => _HomeBannersState();
}

class _HomeBannersState extends State<HomeBanners> {
  late final Future<String?> _gradeIdFuture;

  @override
  void initState() {
    super.initState();
    _gradeIdFuture = SecureStorageHelper.getString(
      key: SecureStorageKeys.gradeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppAnimations.screenSection(delay: 250, child: const TeacherBanner()),
        verticalSpace(35),
        FutureBuilder<String?>(
          future: _gradeIdFuture,
          builder: (context, snapshot) {
            final gradeId = snapshot.data;
            if (gradeId == null || gradeId.trim().isEmpty) {
              return AppAnimations.screenSection(
                delay: 450,
                child: const LiveSessionBanner(isLive: false),
              );
            }
            return BlocProvider(
              create: (_) =>
                  getIt<LiveSessionCubit>()..getLiveSession(gradeId: gradeId),
              child: BlocBuilder<LiveSessionCubit, LiveSessionState>(
                builder: (context, state) {
                  final isLive = state is LiveSessionSuccess;
                  return AppAnimations.screenSection(
                    delay: 450,
                    child: LiveSessionBanner(
                      isLive: isLive,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          RouteNames.liveSessionScreen,
                          arguments: gradeId,
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
