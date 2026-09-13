import 'package:al_waleed/core/style/app_color.dart';
import 'package:al_waleed/core/style/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamSubmittedDetailsCard extends StatelessWidget {
  const ExamSubmittedDetailsCard({
    super.key,
    this.attemptStatus = 'تم التسليم',
    this.resultStatus = '20/100',
  });

  final String attemptStatus;
  final String resultStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: ColorPalette.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(
            color: ColorPalette.ligthBlackShadow,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            _buildRow('حالة المحاولة', attemptStatus),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: const Divider(
                height: 1,
                thickness: 1,
                color: ColorPalette.divider,
              ),
            ),
            _buildRow('النتيجة', resultStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.font12TextSecondaryMediumTajawal()),
        Text(value, style: AppTextStyle.font12TextPrimaryBoldTajawal()),
      ],
    );
  }
}
