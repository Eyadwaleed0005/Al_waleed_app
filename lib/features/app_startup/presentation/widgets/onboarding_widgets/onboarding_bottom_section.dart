import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/onboarding_widgets/onboarding_back_button.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/onboarding_widgets/onboarding_bottom_section_background.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/onboarding_widgets/onboarding_intro_text.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/onboarding_widgets/onboarding_next_button.dart';
import 'package:al_waleed/features/app_startup/presentation/widgets/onboarding_widgets/onboarding_page_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingBottomSection extends StatelessWidget {
  const OnboardingBottomSection({
    super.key,
    required this.subtitle,
    required this.title,
    required this.description,
    required this.onNext,
    required this.onBack,
    required this.currentIndex,
    required this.pageCount,
  });

  final String subtitle;
  final String title;
  final String description;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentIndex;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return OnboardingBottomSectionBackground(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OnboardingIntroText(
              subtitle: subtitle,
              title: title,
              description: description,
            ),
            verticalSpace(20),
            OnboardingPageIndicator(
              currentIndex: currentIndex,
              pageCount: pageCount,
            ),
            verticalSpace(20),
            OnboardingNextButton(onPressed: onNext),
            verticalSpace(8),
            OnboardingBackButton(
              isVisible: currentIndex > 0,
              onPressed: onBack,
            ),
          ],
        ),
      ),
    );
  }
}
