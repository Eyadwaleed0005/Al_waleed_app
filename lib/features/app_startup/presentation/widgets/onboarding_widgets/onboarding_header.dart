import 'package:al_waleed/core/helper/spacer.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.logoAsset,
    required this.onSkip,
  });

  final String logoAsset;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            logoAsset,
            width: 40.w,
            height: 40.h,
            fit: BoxFit.cover,
          ),
        ),
        horizontalSpace(8),
        Text('الوليد', style: AppTextStyle.font20PrimarySemiBoldKufam()),
        const Spacer(),
        TextButton(
          onPressed: onSkip,
          child: Text(
            'تخطي',
            style: AppTextStyle.font14TextSecondaryRegularTajawal(),
          ),
        ),
      ],
    );
  }
}
