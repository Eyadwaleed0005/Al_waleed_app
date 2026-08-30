import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';

class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool showDivider;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyle.font12TextPrimaryBoldTajawal(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Text(
                    label,
                    style: AppTextStyle.font14TextSecondaryRegularTajawal(),
                  ),
                  SizedBox(width: 12.w),
                  Icon(icon, size: 22.sp, color: ColorPalette.textOceanBlue),
                ],
              ),
            ],
          ),
        ),
        if (showDivider) Divider(color: ColorPalette.divider, thickness: 1.h),
      ],
    );
  }
}
