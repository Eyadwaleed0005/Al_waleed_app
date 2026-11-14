import 'package:al_waleed/app/routes/screen_routes/route_names.dart';
import 'package:al_waleed/core/constants/const.dart';
import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/app_animations.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/widgets/app_toast.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/core/widgets/custom_operation_result_dialog.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:al_waleed/features/authentication/presentation/cubit/logout_cubit/logout_state.dart';
import 'package:al_waleed/features/profile/domain/entities/profile_entity.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_widgets_screen/delete_account_dialog.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_widgets_screen/profile_actions_list.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_widgets_screen/profile_background.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_widgets_screen/profile_header_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSuccessView extends StatefulWidget {
  const ProfileSuccessView({
    super.key,
    required this.profile,
    required this.imageAsset,
  });

  final ProfileEntity profile;
  final String imageAsset;

  @override
  State<ProfileSuccessView> createState() {
    return _ProfileSuccessViewState();
  }
}

class _ProfileSuccessViewState extends State<ProfileSuccessView> {
  bool _isOpeningContact = false;
  bool _isDeleteDialogOpen = false;

  bool get _isBusy => _isOpeningContact || _isDeleteDialogOpen;

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              AppAnimations.screenSection(
                delay: 100,
                child: CustomAppBar(
                  title: 'حسابي',
                  backgroundColor: Colors.transparent,
                  showBackButton: false,
                  actions: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 28.r,
                      color: ColorPalette.primary,
                    ),
                  ],
                ),
              ),
              verticalSpace(24),
              AppAnimations.screenSection(
                delay: 250,
                child: ProfileHeaderCard(
                  name: widget.profile.studentProfile.name,
                  email: widget.profile.studentProfile.email,
                  imageAsset: widget.imageAsset,
                ),
              ),
              verticalSpace(24),
              AppAnimations.screenSection(
                delay: 450,
                child: BlocSelector<LogoutCubit, LogoutState, bool>(
                  selector: (state) => state is LogoutLoading,
                  builder: (context, isLoading) {
                    return AbsorbPointer(
                      absorbing: isLoading || _isBusy,
                      child: ProfileActionsList(
                        gradeName: widget.profile.grade.name,
                        onPersonalInfo: () {
                          Navigator.of(
                            context,
                          ).pushNamed(RouteNames.personalInfoScreen);
                        },
                        onSubscription: () {
                          Navigator.of(
                            context,
                          ).pushNamed(RouteNames.mySubscriptionScreen);
                        },
                        onAboutTeacher: () {
                          Navigator.of(
                            context,
                          ).pushNamed(RouteNames.aboutTeacherScreen);
                        },
                        onSupport: _contactSupport,
                        onDeleteAccount: _showDeleteAccountDialog,
                        onLogout: () {
                          if (isLoading || _isBusy) return;

                          _showLogoutDialog();
                        },
                      ),
                    );
                  },
                ),
              ),
              verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    if (_isBusy || context.read<LogoutCubit>().state is LogoutLoading) {
      return;
    }

    setState(() {
      _isDeleteDialogOpen = true;
    });

    try {
      await DeleteAccountDialog.show(context);
    } finally {
      if (mounted) {
        setState(() {
          _isDeleteDialogOpen = false;
        });
      }
    }
  }

  Future<void> _contactSupport() async {
    if (_isBusy || context.read<LogoutCubit>().state is LogoutLoading) {
      return;
    }

    setState(() {
      _isOpeningContact = true;
    });

    try {
      final opened = await launchUrl(
        Uri.parse(Const.teacherWhatsAppUrl),
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        _showContactError();
      }
    } catch (_) {
      if (mounted) {
        _showContactError();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningContact = false;
        });
      }
    }
  }

  void _showContactError() {
    showAppToast(
      context,
      message: 'تعذر فتح واتساب. حاول مرة أخرى.',
      icon: Icons.error_outline_rounded,
    );
  }

  void _showLogoutDialog() {
    final cubit = context.read<LogoutCubit>();

    if (cubit.state is LogoutLoading || _isBusy) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final dialogRoute = ModalRoute.of(dialogContext)!;
        final navigator = Navigator.of(dialogContext);

        return BlocConsumer<LogoutCubit, LogoutState>(
          bloc: cubit,
          listenWhen: (previous, current) {
            return current is LogoutFailure;
          },
          listener: (context, state) {
            if (dialogRoute.isActive) {
              navigator.removeRoute(dialogRoute);
            }
          },
          builder: (context, state) {
            final isLoading = state is LogoutLoading;

            return PopScope(
              canPop: !isLoading,
              child: AbsorbPointer(
                absorbing: isLoading,
                child: CustomOperationResultDialog(
                  type: CustomOperationResultType.failure,
                  failureIcon: Icons.logout_outlined,
                  title: 'تسجيل الخروج',
                  message: 'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
                  actionText: 'تسجيل الخروج',
                  secondaryActionText: 'إلغاء',
                  isLoading: isLoading,
                  onActionPressed: () {
                    if (cubit.state is LogoutLoading) return;

                    cubit.logout();
                  },
                  onSecondaryActionPressed: () {
                    navigator.pop();
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
