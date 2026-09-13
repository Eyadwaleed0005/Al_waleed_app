import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamSubmittedHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const ExamSubmittedHeader({super.key, this.title = 'تم تسليم الاختبار'});

  final String title;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.primary,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56.h,
          child: Center(
            child: Text(
              title,
              style: AppTextStyle.font18CardBackgroundSemiBoldKufam(),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      ),
    );
  }
}
