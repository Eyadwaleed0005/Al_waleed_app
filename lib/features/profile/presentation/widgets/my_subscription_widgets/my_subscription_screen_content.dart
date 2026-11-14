import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/widgets/app_error_state.dart';
import 'package:al_waleed/core/widgets/custom_app_bar.dart';
import 'package:al_waleed/features/profile/presentation/cubit/my_subscription_cubit/my_subscription_cubit.dart';
import 'package:al_waleed/features/profile/presentation/widgets/my_subscription_widgets/my_subscription_loading_skeleton.dart';
import 'package:al_waleed/features/profile/presentation/widgets/my_subscription_widgets/my_subscription_success_view.dart';
import 'package:al_waleed/features/profile/presentation/widgets/profile_widgets_screen/profile_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySubscriptionScreenContent extends StatelessWidget {
  const MySubscriptionScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomAppBar(
                title: 'اشتراكي',
                showBackButton: true,
                backgroundColor: Colors.transparent,
              ),
              verticalSpace(28),
              BlocBuilder<MySubscriptionCubit, MySubscriptionState>(
                builder: (context, state) {
                  if (state is MySubscriptionInitial ||
                      state is MySubscriptionLoading) {
                    return const MySubscriptionLoadingSkeleton();
                  }

                  if (state is MySubscriptionFailure) {
                    return AppErrorState(
                      message: state.error.message,
                      onRetry: () {
                        context.read<MySubscriptionCubit>().retry();
                      },
                    );
                  }

                  if (state is MySubscriptionSuccess) {
                    return MySubscriptionSuccessView(
                      subscription: state.subscription,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              verticalSpace(32),
            ],
          ),
        ),
      ),
    );
  }
}
